const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const authRoutes = require('./routes/auth');  // تأكد من أن المسارات تم استيرادها بشكل صحيح
const walletRoutes = require('./routes/wallet');
const tradingRoutes = require('./routes/trading');
const adminRoutes = require('./routes/admin');
const { connectDB } = require('./config/db');

const app = express();

// إعداد الميدل وير
app.use(cors());
app.use(express.json());

// الاتصال بقاعدة البيانات
connectDB();

// تعيين المسارات
app.use('/api/auth', authRoutes);
app.use('/api/wallet', walletRoutes);
app.use('/api/trading', tradingRoutes);
app.use('/api/admin', adminRoutes);

// بدء تشغيل الخادم
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
