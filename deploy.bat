@echo off
gcloud run deploy tax-consultation-app --source . --region=asia-northeast1 --allow-unauthenticated --set-env-vars="GEMINI_API_KEY=AIzaSyAv-U4FMADKB7WvbXmpKTrcPGyixLhBrIk"