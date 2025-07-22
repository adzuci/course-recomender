# Enrollment Lambda

This Lambda provides student enrollment data from a Postgres database (or mock data if DB is not available).

## Deploy

1. Package and deploy using AWS CLI or Terraform (see root README for infra setup).
2. Set environment variable `DB_URL` for SQLAlchemy (e.g., `postgresql://user:pass@host/db`).

## Test

Invoke with:
```
GET /enrollments?student_id=1
```

## Sample Data
- See `sample_data.sql` for learners, courses, and enrollments.
- See `sqlalchemy_models.py` for schema.

## Without Postgres
If DB is not configured, the Lambda will return static mock enrollments. 