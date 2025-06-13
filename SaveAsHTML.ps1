# 【最終版】ダイアログボックス付き 英語版スクリプト

# クリップボードの内容を取得
Add-Type -AssemblyName System.Windows.Forms
$clipText = [System.Windows.Forms.Clipboard]::GetText()

# HTMLコンテンツを作成
$htmlContent = @"
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>Copied Text</title>
    <style>
        body { font-family: Meiryo, sans-serif; line-height: 1.6; padding: 2em; }
        pre { white-space: pre-wrap; word-wrap: break-word; background-color: #f0f0f0; padding: 1em; border-radius: 5px;}
    </style>
</head>
<body>
    <pre>$($clipText)</pre>
</body>
</html>
"@

# ダイアログボックスの準備
Add-Type -AssemblyName Microsoft.VisualBasic

# デフォルトのファイル名を準備
$defaultName = "clip_" + (Get-Date -Format "yyyyMMdd_HHmmss")

# ダイアログボックスを表示 (英語表示で文字化けを回避)
$fileNameBase = [Microsoft.VisualBasic.Interaction]::InputBox("Enter a file name (extension is not needed):", "File Name Input", $defaultName)

# キャンセルされた場合は終了
if ([string]::IsNullOrWhiteSpace($fileNameBase)) {
    exit
}

# ファイル名と保存先を設定
$fileName = $fileNameBase + ".html"
$savePath = "C:\Users\mi_tsuji\Desktop\shortcut"

# フォルダがなければ作成
if (-not (Test-Path -Path $savePath)) {
    New-Item -Path $savePath -ItemType Directory
}

$filePath = Join-Path -Path $savePath -ChildPath $fileName

# ファイルを保存
$htmlContent | Out-File -FilePath $filePath -Encoding UTF8