 
const express = require('express');
const router = express.Router();
const {
  getPendingTransactions,
  handleTransaction,
  getDepositAddresses,
  changeDepositAddress,
} = require('../controllers/adminController');
const authMiddleware = require('../middleware/authMiddleware');
const adminMiddleware = require('../middleware/adminMiddleware');

router.get('/transactions/pending', authMiddleware, adminMiddleware, getPendingTransactions);
router.post('/transactions/handle', authMiddleware, adminMiddleware, handleTransaction);
router.get('/addresses', authMiddleware, adminMiddleware, getDepositAddresses);
router.post('/addresses/change', authMiddleware, adminMiddleware, changeDepositAddress);

module.exports = router;