/**
 * Cloud SQL (PostgreSQL) integration for StudyQuest.
 *
 * Architecture: Flutter -> Cloud Functions (callable) -> Cloud SQL.
 * The Flutter app NEVER talks to PostgreSQL directly (security).
 *
 * All functions are gated behind the ENABLE_CLOUD_SQL feature flag
 * (see .env / .env.example per SOP: new features default to disabled).
 */
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { Pool } = require('pg');

const isCloudSqlEnabled = () =>
  functions.config().cloudsql && functions.config().cloudsql.enabled === 'true';

// Lazy-initialized connection pool (Cloud SQL Auth proxy via unix socket).
let pool = null;
function getPool() {
  if (pool) return pool;
  const config = functions.config().cloudsql || {};
  pool = new Pool({
    user: config.db_user || 'postgres',
    password: config.db_password || '',
    database: config.db_name || 'studyquest',
    host: `/cloudsql/${config.connection_name || ''}`,
    max: 5,
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 10000,
  });
  return pool;
}

/**
 * recordStudySession (callable)
 *
 * Demonstrates: validation, foreign keys, idempotency, and a transaction that
 * atomically inserts a session and updates the aggregate stats row.
 *
 * Payload: { roomId, durationMinutes, xpEarned, idempotencyKey }
 */
exports.recordStudySession = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'Authentication required.'
    );
  }
  if (!isCloudSqlEnabled()) {
    throw new functions.https.HttpsError(
      'failed-precondition',
      'Cloud SQL integration is disabled (feature flag).'
    );
  }

  const uid = context.auth.uid;
  const durationMinutes = Number(data.durationMinutes);
  const xpEarned = Number(data.xpEarned || 0);
  const idempotencyKey = String(data.idempotencyKey || '');
  const roomId = data.roomId ? String(data.roomId) : null;

  // Server-side validation (never trust the client).
  if (!Number.isInteger(durationMinutes) || durationMinutes <= 0 || durationMinutes > 600) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'durationMinutes must be an integer between 1 and 600.'
    );
  }
  if (!Number.isInteger(xpEarned) || xpEarned < 0 || xpEarned > 10000) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'xpEarned must be an integer between 0 and 10000.'
    );
  }
  if (!idempotencyKey || idempotencyKey.length > 255) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'idempotencyKey is required (max 255 chars).'
    );
  }

  const sql = getPool();
  const client = await sql.connect();
  try {
    await client.query('BEGIN');

    // Ensure the user row exists (FK target). Upsert is idempotent.
    await client.query(
      `INSERT INTO users (uid, email, display_name)
       VALUES ($1, $2, $3)
       ON CONFLICT (uid) DO NOTHING`,
      [uid, context.auth.token.email || '', context.auth.token.name || 'User']
    );

    // Idempotency: if this key was already recorded, return the existing row.
    const existing = await client.query(
      'SELECT id FROM study_sessions WHERE idempotency_key = $1',
      [idempotencyKey]
    );
    if (existing.rowCount > 0) {
      await client.query('COMMIT');
      return { status: 'duplicate', sessionId: existing.rows[0].id };
    }

    // Insert the session row.
    const inserted = await client.query(
      `INSERT INTO study_sessions
         (id, user_id, room_id, duration_minutes, xp_earned, idempotency_key, started_at, ended_at)
       VALUES (gen_random_uuid(), $1, $2, $3, $4, $5, NOW() - make_interval(mins => $3), NOW())
       RETURNING id`,
      [uid, roomId, durationMinutes, xpEarned, idempotencyKey]
    );
    const sessionId = inserted.rows[0].id;

    // Atomically update aggregate stats (same transaction).
    await client.query(
      `INSERT INTO user_stats (user_id, total_minutes, total_sessions, total_xp, last_session_at, updated_at)
       VALUES ($1, $2, 1, $3, NOW(), NOW())
       ON CONFLICT (user_id) DO UPDATE SET
         total_minutes = user_stats.total_minutes + $2,
         total_sessions = user_stats.total_sessions + 1,
         total_xp = user_stats.total_xp + $3,
         last_session_at = NOW(),
         updated_at = NOW()`,
      [uid, durationMinutes, xpEarned]
    );

    // Record the XP event (unique constraint makes this idempotent too).
    if (xpEarned > 0) {
      await client.query(
        `INSERT INTO xp_events (user_id, source, ref_id, amount)
         VALUES ($1, 'session', $2, $3)
         ON CONFLICT (source, ref_id) DO NOTHING`,
        [uid, idempotencyKey, xpEarned]
      );
    }

    await client.query('COMMIT');

/**
 * getFriendLeaderboard (callable)
 *
 * Demonstrates: JOIN across users/friendships/user_stats with index scans
 * on idx_friendships_user_status and idx_study_sessions_user_started.
 */
exports.getFriendLeaderboard = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'Authentication required.'
    );
  }
  if (!isCloudSqlEnabled()) {
    throw new functions.https.HttpsError(
      'failed-precondition',
      'Cloud SQL integration is disabled (feature flag).'
    );
  }

  const uid = context.auth.uid;
  const sql = getPool();

  const result = await sql.query(
    `SELECT u.uid, u.display_name,
            COALESCE(s.total_minutes, 0) AS total_minutes,
            COALESCE(s.total_sessions, 0) AS total_sessions,
            COALESCE(s.total_xp, 0)       AS total_xp
       FROM friendships f
       JOIN users u       ON u.uid = f.friend_id
       LEFT JOIN user_stats s ON s.user_id = u.uid
      WHERE f.user_id = $1 AND f.status = 'accepted'
      ORDER BY total_xp DESC, total_minutes DESC
      LIMIT 20`,
    [uid]
  );

  return { leaderboard: result.rows };
});

/**
 * syncUserToSql (Auth trigger)
 *
 * Keeps the relational users table in sync with new Firebase Auth accounts
 * so foreign keys always have a target row.
 */
exports.syncUserToSql = functions.auth.user().onCreate(async (user) => {
  if (!isCloudSqlEnabled()) return null;
  try {
    const sql = getPool();
    await sql.query(
      `INSERT INTO users (uid, email, display_name)
       VALUES ($1, $2, $3)
       ON CONFLICT (uid) DO UPDATE SET
         email = EXCLUDED.email,
         display_name = EXCLUDED.display_name`,
      [user.uid, user.email || '', (user.displayName || user.email || 'User').slice(0, 120)]
    );
  } catch (e) {
    // Non-fatal: recordStudySession also upserts the user row.
    console.error('[syncUserToSql] failed:', e);
  }
  return null;
});

    return { status: 'recorded', sessionId };
  } catch (e) {
    await client.query('ROLLBACK');
    console.error('[recordStudySession] failed:', e);
    throw new functions.https.HttpsError('internal', 'Failed to record session.');
  } finally {
    client.release();
  }
});