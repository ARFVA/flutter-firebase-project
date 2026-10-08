# Cloud SQL PostgreSQL Documentation

## Overview
Cloud SQL PostgreSQL is used for complex relational data that requires transactions and complex queries.

## Database Schema

### users_extended
```sql
CREATE TABLE users_extended (
  user_id VARCHAR(255) PRIMARY KEY,
  friend_id VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(uid),
  FOREIGN KEY (friend_id) REFERENCES users(uid)
);
```

### analytics
```sql
CREATE TABLE analytics (
  id SERIAL PRIMARY KEY,
  user_id VARCHAR(255) NOT NULL,
  event_type VARCHAR(100) NOT NULL,
  event_data JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(uid)
);
```

## Connection Architecture
- Client (Flutter) → Cloud Functions → Cloud SQL
- Direct connection from Flutter is NOT allowed (security risk)
- All database operations go through Cloud Functions

## Deployment
```bash
gcloud sql instances create studyquest-db --tier=db-f1-micro --region=us-central1
gcloud sql databases create studyquest --instance=studyquest-db
```

## Security
- Use Cloud SQL Auth Proxy
- Never expose database credentials to client
- Use VPC connectors for Cloud Functions
