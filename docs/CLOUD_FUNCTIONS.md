# Cloud Functions Documentation

## Overview
Cloud Functions untuk Firebase mengimplementasikan logika bisnis di sisi server
yang memerlukan akses server. Penyelesaian quest dan award XP aplikasi tidak
memerlukan Cloud Functions; keduanya memakai transaksi Firestore dan security
rules agar tetap berjalan pada paket Spark.

## Implemented Functions

### `onQuestComplete` (Firestore `onUpdate` trigger, opsional)
Trigger kompatibilitas untuk instalasi lama yang pernah memakai Cloud
Functions. Aplikasi saat ini menyelesaikan quest dan memberi XP langsung lewat
transaksi Firestore; rules mewajibkan quest, profil, dan activity berubah
bersama serta menolak award kedua.

- **Validasi server-side**: XP harus `integer` 1..10,000; quest harus punya
  `userId`.
- **Idempotency**: menggunakan Firestore **transaction** yang menyalakan flag
  `xpAwarded` pada dokumen quest. Hanya transaksi yang berhasil menyalakan flag
  yang memberi XP, sehingga retry/trigger ganda tidak menggandakan XP. ID
  dokumen aktivitas diturunkan dari quest ID (`quest_{questId}`) sehingga retry
  juga tidak membuat aktivitas kembar.
- **Streak**: `lastStreakDate` dicek — streak naik maksimal sekali per hari,
  dan hanya jika streak aktif kemarin; selain itu di-reset ke 1.

### `onUserCreated` (Auth `onCreate` trigger, opsional)
Membuat profil Firestore saat user Firebase Auth terdaftar.
- **Validasi/sanitasi**: `displayName` dipotong maks 80 karakter, email
  dinormalisasi, tidak menimpa profil yang sudah ada (idempoten).

### `dailyStreakCheck` (Pub/Sub schedule harian, 00:00 UTC, opsional)
Me-reset `streak` user yang tidak aktif lebih dari satu hari
(`lastStreakDate` < kemarin). Memakai batch 500 untuk aman terhadap limit.

### `recordStudySession` (Callable, butuh Cloud SQL dan Blaze)
Mencatat sesi belajar ke PostgreSQL dengan **transaction** (INSERT sesi +
UPDATE statistik atomik) dan **idempotency key**.

### `getFriendLeaderboard` (Callable, butuh Cloud SQL dan Blaze)
Leaderboard teman via **JOIN** `friendships`/`users`/`user_stats` dengan index.

### `syncUserToSql` (Auth `onCreate` trigger, butuh Cloud SQL dan Blaze)
Menjaga baris `users` di Cloud SQL sinkron dengan Firebase Auth.

## Deployment (opsional)
```bash
# Deploy functions requires a Firebase billing plan that supports Cloud Build.
firebase deploy --only functions
```

## Konfigurasi (feature flag)
Cloud SQL functions dikendalikan config `cloudsql.enabled` (lihat
[CLOUD_SQL.md](CLOUD_SQL.md)). Saat mati, callable mengembalikan
`failed-precondition` tanpa menyentuh database.

## Security
- Functions berjalan dengan admin privileges (melewati security rules).
- Karena itu semua **validasi wajib dilakukan di dalam functions** — tidak ada
  logika kritis yang dipercaya dari klien.
- Untuk alur Spark tanpa Functions, Firestore rules mengizinkan perubahan
  `xp`/`level` hanya bersama penyelesaian quest milik pengguna dan activity
  yang cocok dalam satu transaksi. XP dihitung dari nilai quest yang telah
  tersimpan; rules menolak reward ganda.
- Jangan deploy Functions dari project Spark; Firestore transactions dan rules
  sudah cukup untuk alur XP quest aplikasi.
