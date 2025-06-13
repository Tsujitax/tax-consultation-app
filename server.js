const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 8080;

// 環境変数からAPIキーを取得
const GEMINI_API_KEY = process.env.GEMINI_API_KEY;

if (!GEMINI_API_KEY) {
    console.warn('WARNING: GEMINI_API_KEY is not set in environment variables');
}

// JSONボディのパース
app.use(express.json());

// 静的ファイルの提供
app.use(express.static(path.join(__dirname, 'public')));

// メモリ内でのシンプルな統計情報（本番環境ではデータベースを使用すべき）
let stats = {
    totalAccess: 0,
    totalConsultations: 0,
    startTime: new Date()
};

// アクセス数のカウント
app.use((req, res, next) => {
    if (req.path === '/' || req.path === '/index.html') {
        stats.totalAccess++;
        console.log(`Access count: ${stats.totalAccess}`);
    }
    next();
});

// APIキーを返すエンドポイント
app.get('/api/config', (req, res) => {
    if (!GEMINI_API_KEY) {
        return res.status(500).json({ error: 'API key not configured' });
    }
    res.json({ apiKey: GEMINI_API_KEY });
});

// 相談内容を記録するエンドポイント（匿名化）
app.post('/api/log-consultation', (req, res) => {
    const { consultationType } = req.body; // 'scolding' or 'suggestion'
    
    stats.totalConsultations++;
    
    // ログ出力（本番環境ではCloud Loggingに記録される）
    console.log(`Consultation logged: Type=${consultationType}, Total=${stats.totalConsultations}`);
    
    res.json({ success: true });
});

// 統計情報を取得するエンドポイント（管理者用）
app.get('/api/stats', (req, res) => {
    res.json({
        totalAccess: stats.totalAccess,
        totalConsultations: stats.totalConsultations,
        uptime: Math.floor((new Date() - stats.startTime) / 1000 / 60) + ' minutes'
    });
});

// すべてのルートでindex.htmlを返す（SPA対応）
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
    console.log(`API Key configured: ${GEMINI_API_KEY ? 'Yes' : 'No'}`);
});