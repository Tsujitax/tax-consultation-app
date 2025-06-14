# USJ Mood Navigator v2 デプロイ手順

## 改善内容
- ✨ 魅力的なビジュアルデザイン
- 🎨 SVGベースの背景画像（外部画像依存なし）
- 🎯 USJアトラクションに対応したアイコン
- 📱 完全レスポンシブデザイン
- 🎉 アニメーション効果

## デプロイ方法

### 1. 依存関係のインストール
```bash
cd C:\Users\mi_tsuji\Desktop\shortcut\usj-mood-navigator-v2
npm install
```

### 2. 新しいサービスとしてデプロイ
```bash
gcloud run deploy usj-mood-navigator-v2 --source . --region=asia-northeast1 --allow-unauthenticated --set-env-vars="GEMINI_API_KEY=AIzaSyCaAgnJj1kMKHshlYtgHjJyyC1DSGR65ic"
```

### 3. または既存サービスを置き換え
```bash
gcloud run deploy usj-mood-navigator --source . --region=us-west1 --allow-unauthenticated --set-env-vars="API_KEY=AIzaSyCaAgnJj1kMKHshlYtgHjJyyC1DSGR65ic"
```

## 特徴
- 外部画像に依存しない（すべてSVGとEmoji）
- 高速ローディング
- 美しいグラデーション背景
- インタラクティブなUI