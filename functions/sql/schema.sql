-- StudyQuest Cloud SQL PostgreSQL schema
-- Relational modeling: foreign keys, indexes, constraints.
-- Accessed ONLY via Cloud Functions (never directly from Flutter).

-- Synced mirror of Firebase Auth users (source of truth for relational data).
CREATE TABLE IF NOT EXISTS users (
  uid          VARCHAR(128) PRIMARY KEY,
  email        VARCHAR(255) UNIQUE,
  display_name VARCHAR(120) NOT NULL,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Friends / study partners (many-to-many with a status).
CREATE TABLE IF NOT EXISTS friendships (
  id         BIGSERIAL PRIMARY KEY,
  user_id    VARCHAR(128) NOT NULL REFERENCES users(uid) ON DELETE CASCADE,
  friend_id  VARCHAR(128) NOT NULL REFERENCES users(uid) ON DELETE CASCADE,
  status     VARCHAR(20)  NOT NULL DEFAULT 'pending'
             CHECK (status IN ('pending', 'accepted', 'blocked')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  -- A user cannot friend themselves, and pairs are unique (unordered).
  CONSTRAINT no_self_friendship CHECK (user_id <> friend_id),
  UNIQUE (user_id, friend_id)
);
CREATE INDEX IF NOT EXISTS idx_friendships_user_status
  ON friendships (user_id, status);

-- Completed study sessions; the unit of analytics and leaderboard.
CREATE TABLE IF NOT EXISTS study_sessions (
  id               UUID PRIMARY KEY,
  user_id          VARCHAR(128) NOT NULL REFERENCES users(uid) ON DELETE CASCADE,
  room_id          VARCHAR(128),
  duration_minutes INTEGER NOT NULL CHECK (duration_minutes > 0 AND duration_minutes <= 600),
  xp_earned        INTEGER NOT NULL DEFAULT 0 CHECK (xp_earned >= 0),
  idempotency_key  VARCHAR(255) NOT NULL UNIQUE,  -- prevents double inserts
  started_at       TIMESTAMPTZ NOT NULL,
  ended_at         TIMESTAMPTZ NOT NULL,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT valid_window CHECK (ended_at > started_at)
);
CREATE INDEX IF NOT EXISTS idx_study_sessions_user_started
  ON study_sessions (user_id, started_at DESC);

-- Aggregated per-user stats, maintained transactionally on session insert.
CREATE TABLE IF NOT EXISTS user_stats (
  user_id          VARCHAR(128) PRIMARY KEY REFERENCES users(uid) ON DELETE CASCADE,
  total_minutes    INTEGER NOT NULL DEFAULT 0,
  total_sessions   INTEGER NOT NULL DEFAULT 0,
  total_xp         INTEGER NOT NULL DEFAULT 0,
  last_session_at  TIMESTAMPTZ,
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Audit log of XP awards (relational complement to Firestore activities).
CREATE TABLE IF NOT EXISTS xp_events (
  id         BIGSERIAL PRIMARY KEY,
  user_id    VARCHAR(128) NOT NULL REFERENCES users(uid) ON DELETE CASCADE,
  source     VARCHAR(50)  NOT NULL,               -- 'quest', 'streak', 'bonus'
  ref_id     VARCHAR(128),                        -- quest id / cron id
  amount     INTEGER NOT NULL CHECK (amount > 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (source, ref_id)                         -- idempotent awarding
);
CREATE INDEX IF NOT EXISTS idx_xp_events_user_created
  ON xp_events (user_id, created_at DESC);