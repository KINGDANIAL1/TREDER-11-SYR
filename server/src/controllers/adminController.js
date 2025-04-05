 
const Transaction = require('../models/Transaction');
const Wallet = require('../models/Wallet');
const { sendNotification } = require('../utils/notifications');
const { generateDepositAddress } = require('../utils/blockchain');

exports.getPendingTransactions = async (req, res) => {
  try {
    if (!req.user.isAdmin) return res.status(403).json({ message: 'Admin only' });
    const transactions = await Transaction.find({ status: 'pending' });
    res.json(transactions);
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
};

exports.handleTransaction = async (req, res) => {
  try {
    if (!req.user.isAdmin) return res.status(403).json({ message: 'Admin only' });
    const { transactionId, action } = req.body;
    const transaction = await Transaction.findById(transactionId);
    if (!transaction) return res.status(404).json({ message: 'Transaction not found' });

    const wallet = await Wallet.findOne({ userId: transaction.userId });

    if (action === 'approve') {
      if (transaction.type === 'deposit') {
        wallet.balances[transaction.currency.toLowerCase()] += transaction.amount;
      } else if (transaction.type === 'withdraw') {
        if (wallet.balances[transaction.currency.toLowerCase()] < transaction.amount) {
          return res.status(400).json({ message: 'Insufficient balance' });
        }
        wallet.balances[transaction.currency.toLowerCase()] -= transaction.amount;
      }
      transaction.status = 'approved';
      await wallet.save();
    } else {
      transaction.status = 'rejected';
    }

    await transaction.save();
    await sendNotification(
      transaction.userId,
      'Transaction Update',
      `Your ${transaction.type} request has been ${action}d`
    );
    res.json({ success: true, message: `Transaction ${action}d` });
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
};

exports.getDepositAddresses = async (req, res) => {
  try {
    if (!req.user.isAdmin) return res.status(403).json({ message: 'Admin only' });
    const wallets = await Wallet.find();
    const addresses = {};
    wallets.forEach(wallet => {
      Object.assign(addresses, wallet.depositAddresses);
    });
    res.json(addresses);
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
};

exports.changeDepositAddress = async (req, res) => {
  try {
    if (!req.user.isAdmin) return res.status(403).json({ message: 'Admin only' });
    const { currency } = req.body;
    const wallet = await Wallet.findOne({ userId: req.user.id });
    const newAddress = generateDepositAddress(currency);
    wallet.depositAddresses[currency] = newAddress;
    await wallet.save();
    await sendNotification(req.user.id, 'Address Changed', `New ${currency} address: ${newAddress}`);
    res.json({ success: true, newAddress });
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
};