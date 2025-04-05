 
const mongoose = require('mongoose');

const walletSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  balances: {
    btc: { type: Number, default: 0 },
    eth: { type: Number, default: 0 },
    usdt: { type: Number, default: 0 },
  },
  depositAddresses: {
    btc: { type: String },
    eth: { type: String },
    usdt: { type: String },
  },
  updatedAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model('Wallet', walletSchema);