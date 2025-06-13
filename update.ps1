# GitHubに更新をプッシュするスクリプト
Write-Host "GitHubに更新をプッシュします..." -ForegroundColor Green

# 変更を追加
git add .

# コミットメッセージを入力
$message = Read-Host "コミットメッセージを入力してください"
if ([string]::IsNullOrWhiteSpace($message)) {
    $message = "Update files"
}

# コミット
git commit -m $message

# プッシュ
Write-Host "GitHubにプッシュ中..." -ForegroundColor Yellow
git push

Write-Host "完了！Cloud Runが自動的にデプロイを開始します。" -ForegroundColor Green
Write-Host "2-3分後に変更が反映されます。" -ForegroundColor Cyan