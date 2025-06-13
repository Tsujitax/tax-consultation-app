# 脱税相談叱責アプリ - Google Cloud Run デプロイガイド

このガイドでは、脱税相談叱責アプリをGoogle Cloud Runにデプロイする手順を説明します。

## 前提条件

1. Google Cloud Platform (GCP) アカウント
2. Google Cloud CLI (`gcloud`) がインストール済み
3. Docker がインストール済み（ローカルでビルドする場合）
4. Gemini API キー（[Google AI Studio](https://makersuite.google.com/app/apikey)から取得）

## デプロイ手順

### 1. プロジェクトの準備

```bash
# GCPプロジェクトIDを設定（your-project-idを実際のプロジェクトIDに置き換える）
export PROJECT_ID=your-project-id

# gcloudの設定
gcloud config set project $PROJECT_ID

# Cloud Run APIを有効化
gcloud services enable run.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable artifactregistry.googleapis.com
```

### 2. Artifact Registry の作成（初回のみ）

```bash
# リポジトリを作成
gcloud artifacts repositories create cloud-run-source-deploy \
    --repository-format=docker \
    --location=asia-northeast1 \
    --description="Cloud Run source deployment"
```

### 3. デプロイ方法

#### 方法A: ソースからの直接デプロイ（推奨）

```bash
# 環境変数付きでデプロイ
gcloud run deploy tax-consultation-app \
    --source . \
    --region=asia-northeast1 \
    --platform=managed \
    --allow-unauthenticated \
    --set-env-vars="GEMINI_API_KEY=your-gemini-api-key-here"
```

#### 方法B: ローカルでDockerビルドしてデプロイ

```bash
# Dockerイメージをビルド
docker build -t gcr.io/$PROJECT_ID/tax-consultation-app .

# イメージをプッシュ
docker push gcr.io/$PROJECT_ID/tax-consultation-app

# Cloud Runにデプロイ
gcloud run deploy tax-consultation-app \
    --image gcr.io/$PROJECT_ID/tax-consultation-app \
    --region=asia-northeast1 \
    --platform=managed \
    --allow-unauthenticated \
    --set-env-vars="GEMINI_API_KEY=your-gemini-api-key-here"
```

### 4. APIキーの安全な管理（推奨）

本番環境では、APIキーをSecret Managerで管理することを推奨します：

```bash
# Secret Managerを有効化
gcloud services enable secretmanager.googleapis.com

# シークレットを作成
echo -n "your-gemini-api-key-here" | gcloud secrets create gemini-api-key --data-file=-

# Cloud RunサービスアカウントにSecret Managerへのアクセス権限を付与
gcloud secrets add-iam-policy-binding gemini-api-key \
    --member="serviceAccount:$(gcloud iam service-accounts list --filter="email:~compute@developer.gserviceaccount.com" --format="value(email)")" \
    --role="roles/secretmanager.secretAccessor"

# シークレットを使用してデプロイ
gcloud run deploy tax-consultation-app \
    --source . \
    --region=asia-northeast1 \
    --platform=managed \
    --allow-unauthenticated \
    --set-secrets="GEMINI_API_KEY=gemini-api-key:latest"
```

### 5. デプロイの確認

デプロイが完了すると、URLが表示されます：

```
Service URL: https://tax-consultation-app-xxxxx-an.a.run.app
```

このURLにアクセスしてアプリケーションが正常に動作することを確認してください。

## トラブルシューティング

### APIキーが機能しない場合

1. ブラウザの開発者ツール（F12）でコンソールを確認
2. ネットワークタブで `/api/config` へのリクエストを確認
3. Cloud Runのログを確認：
   ```bash
   gcloud run logs read --service=tax-consultation-app --region=asia-northeast1
   ```

### デプロイが失敗する場合

1. Cloud Build のログを確認
2. Dockerfileの構文を確認
3. package.jsonの依存関係を確認

## 更新方法

アプリケーションを更新する場合は、同じデプロイコマンドを再実行するだけです：

```bash
gcloud run deploy tax-consultation-app \
    --source . \
    --region=asia-northeast1 \
    --allow-unauthenticated
```

## コスト管理

- Cloud Runは使用した分だけ課金されます
- 無料枠：月間200万リクエストまで無料
- 使用していない時は課金されません

## セキュリティ上の注意

- APIキーは必ず環境変数またはSecret Managerで管理
- HTTPSが自動的に有効化されます
- 必要に応じて認証を追加することも可能です