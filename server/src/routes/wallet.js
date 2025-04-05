const express = require('express');
const router = express.Router();
const { getWallet, getDepositAddress, requestWithdrawal } = require('../controllers/walletController');
const authMiddleware = require('../middleware/authMiddleware');

// مسار جلب معلومات المحفظة
router.get('/', authMiddleware, getWallet);

// مسار جلب عنوان الإيداع
router.get('/deposit-address', authMiddleware, getDepositAddress);

// مسار طلب السحب
router.post('/withdraw', authMiddleware, requestWithdrawal);

module.exports = router;
