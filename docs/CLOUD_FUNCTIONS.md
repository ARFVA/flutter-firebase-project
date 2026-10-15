# Cloud Functions Documentation

## Overview
Cloud Functions untuk Firebase mengimplementasikan logika bisnis di sisi server
yang tidak aman/duplikasi jika dijalankan di klien: perhitungan XP, level,
streak, dan validasi penyelesaian quest.

## Implemented Functions

### 1. `onQuestComplete` (Firestore `onUpdate` trigger)
Dijalankan ketika dokumen quest berubah. Memberi XP **tepat satu kali** ketika
quest bertransisi incomplete → complete.

- **Validasi server-side**: XP harus `integer` 1..10,000; quest harus punya
  `userId`; profil user harus ada.
- **Idempotency**: menggunakan Firestore **transaction** yang menyalakan flag
  `xpAwarded` pada dokumen quest. Hanya transaksi yang berhasil menyalakan flag
  yang memberi XP, sehingga retry/trigger ganda tidak menggandakan XP. ID
  dokumen aktivitas diturunkan dari quest ID (`quest_{questId}`) sehingga retry
  juga tidak membuat aktivitas kembar.
- **Streak**: `lastStreakDate` dicek — streak naik maksimal sekali per hari,
  dan hanya jika streak aktif kemarin; selain itu di-reset ke 1.

### 2. `onUserCreated` (Auth `onCreate` trigger)
Membuat profil Firestore saat user Firebase Auth terdaftar.
- **Validasi/sanitasi**: `displayName` dipotong maks 80 karakter, email
  dinormalisasi, tidak menimpa profil yang sudah ada (idempoten).

### 3. `dailyStreakCheck` (Pub/Sub schedule harian, 00:00 UTC)
Me-reset `streak` user yang tidak aktif lebih dari satu hari
(`lastStreakDate` < kemarin). Memakai batch 500 untuk aman terhadap limit.

### 4. `recordStudySession` (Callable, butuh Cloud SQL)
Mencatat sesi belajar ke PostgreSQL dengan **transaction** (INSERT sesi +
UPDATE statistik atomik) dan **idempotency key**.

### 5. `getFriendLeaderboard` (Callable, butuh Cloud SQL)
Leaderboard teman via **JOIN** `friendships`/`users`/`user_stats` dengan index.

### 6. `syncUserToSql` (Auth `onCreate` trigger, butuh Cloud SQL)
Menjaga baris `users` di Cloud SQL sinkron dengan Firebase Auth.

## Deployment
```bash
# Semua functions
firebase deploy --only functions

# Atau per fungsi
firebase deploy --only functions:onQuestComplete
```

## Konfigurasi (feature flag)
Cloud SQL functions dikendalikan config `cloudsql.enabled` (lihat
[CLOUD_SQL.md](CLOUD_SQL.md)). Saat mati, callable mengembalikan
`failed-precondition` tanpa menyentuh database.

## Security
- Functions berjalan dengan admin privileges (melewati security rules).
- Karena itu semua **validasi wajib dilakukan di dalam functions** — tidak ada
  logika kritis yang dipercaya dari klien.
- Klien tidak bisa mengubah `xp`/`level`/`streak` (diblokir security rules);
  hanya functions ini yang menghitungnya.
- All validation happens server-side
- Cannot be bypassed by client manipulation
