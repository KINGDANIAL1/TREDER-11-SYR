const express = require('express');
const router = express.Router();
const { register, login, changePassword } = require('../controllers/authController');

// تأكد من أن هذه الدوال صحيحة
router.post('/register', register);
router.post('/login', login);
router.post('/change-password', changePassword);

module.exports = router;
