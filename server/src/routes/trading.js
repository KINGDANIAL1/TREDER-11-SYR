// server/src/routes/trading.js
const express = require('express');
const router = express.Router();
const { getMarketData, placeOrder } = require('../controllers/tradingController');
const authMiddleware = require('../middleware/authMiddleware');

router.get('/market', authMiddleware, getMarketData);
router.post('/order', authMiddleware, placeOrder);

module.exports = router;