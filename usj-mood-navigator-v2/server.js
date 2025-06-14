const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 8080;

// 環境変数からAPIキーを取得
const GEMINI_API_KEY = process.env.GEMINI_API_KEY || process.env.API_KEY;

if (!GEMINI_API_KEY) {
    console.warn('WARNING: GEMINI_API_KEY is not set in environment variables');
}

// 静的ファイルの提供
app.use(express.static(path.join(__dirname)));

// APIキーを返すエンドポイント
app.get('/api/config', (req, res) => {
    if (!GEMINI_API_KEY) {
        return res.status(500).json({ error: 'API key not configured' });
    }
    res.json({ apiKey: GEMINI_API_KEY });
});

// ルートでindex.htmlを返す
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
    console.log(`API Key configured: ${GEMINI_API_KEY ? 'Yes' : 'No'}`);
});