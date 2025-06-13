# Google Cloud Run デプロイスクリプト
$ErrorActionPreference = "Stop"

Write-Host "脱税相談叱責アプリをGoogle Cloud Runにデプロイします..." -ForegroundColor Green

# APIキーを環境変数から読み取るか、直接指定
$apiKey = "AIzaSyAv-U4FMADKB7WvbXmpKTrcPGyixLhBrIk"

# デプロイコマンドを実行
gcloud run deploy tax-consultation-app `
    --source . `
    --region=asia-northeast1 `
    --allow-unauthenticated `
    --set-env-vars="GEMINI_API_KEY=$apiKey"

Write-Host "デプロイが完了しました！" -ForegroundColor Green