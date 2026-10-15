# Cloud SQL PostgreSQL Documentation

## Overview
Cloud SQL PostgreSQL menyimpan data relasional yang butuh foreign key, JOIN,
index, dan transaction. **Flutter tidak pernah terhubung langsung ke PostgreSQL**
(semua akses lewat Cloud Functions untuk keamanan).

## Connection Architecture
```
Client (Flutter)
   └── Callable Cloud Functions (recordStudySession, getFriendLeaderboard)
          └── Cloud SQL (PostgreSQL) via Cloud SQL Auth proxy (unix socket)
```

## Feature Flag
Integrasi Cloud SQL dikendalikan oleh feature flag (default **false** sesuai SOP):

```bash
firebase functions:config:set cloudsql.enabled="true" \
  cloudsql.connection_name="PROJECT:REGION:INSTANCE" \
  cloudsql.db_user="postgres" \
  cloudsql.db_password="..." \
  cloudsql.db_name="studyquest"
```

Saat flag mati, callable mengembalikan `failed-precondition` (graceful).

## Database Schema
Skema lengkap ada di [`functions/sql/schema.sql`](../functions/sql/schema.sql).

| Table | Purpose | Relational Features |
|-------|---------|---------------------|
| `users` | Mirror Firebase Auth users | PK `uid`, UNIQUE `email` |
| `friendships` | Relasi teman/partner | FK → `users`, CHECK, UNIQUE pair, index `(user_id, status)` |
| `study_sessions` | Sesi belajar selesai | FK → `users`, CHECK durasi, UNIQUE `idempotency_key`, index `(user_id, started_at)` |
| `user_stats` | Aggregate statistik | PK/FK → `users` |
| `xp_events` | Audit log XP | FK → `users`, UNIQUE `(source, ref_id)` untuk idempoten |

## Contoh Fitur yang Didemonstrasikan
- **Foreign Key**: `study_sessions.user_id` → `users.uid` (dengan `ON DELETE CASCADE`)
- **Transaction**: `recordStudySession` meng-INSERT sesi + UPDATE `user_stats` secara atomik dalam satu transaction (ada `BEGIN`/`COMMIT`/`ROLLBACK`)
- **Idempotency**: UNIQUE `idempotency_key` + pengecekan sebelum insert mencegah duplikasi sesi
- **JOIN + Index**: `getFriendLeaderboard` melakukan `JOIN friendships/users/user_stats` dengan index scan

## Deployment
```bash
# 1. Buat instance (sekali)
gcloud sql instances create studyquest-db --tier=db-f1-micro --region=asia-southeast1
gcloud sql databases create studyquest --instance=studyquest-db

# 2. Terapkan skema
psql "$CONN_STRING" -f functions/sql/schema.sql

# 3. Deploy functions
firebase deploy --only functions

# 4. Aktifkan feature flag (lihat di atas)
```

## Security
- Kredensial DB hanya di environment backend (bukan di repo/klien)
- Koneksi via Cloud SQL Auth proxy (unix socket `/cloudsql/...`)
- Semua input divalidasi server-side sebelum menyentuh SQL
