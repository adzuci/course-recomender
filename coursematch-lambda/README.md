# Recommendation Lambda

This Lambda provides course recommendations for students, using Algolia for vector search (or mock data if Algolia is not configured).

## Deploy

1. Package and deploy using AWS CLI or Terraform (see root README for infra setup).
2. Set environment variables for Algolia (if using):
   - `ALGOLIA_APP_ID`
   - `ALGOLIA_API_KEY`
   - `ALGOLIA_INDEX_NAME`

## Test

Invoke with:
```
GET /recommendations?student_id=1
```

## Sample Algolia Data
See `algolia_sample.json` for example index records.

## Without Algolia
If Algolia is not configured, the Lambda will return static mock recommendations. 