 
const Wallet = require('../models/Wallet');
const Transaction = require('../models/Transaction');
const { generateDepositAddress } = require('../utils/blockchain');
const { sendNotification } = require('../utils/notifications');

exports.getWallet = async (req, res) => {
  try {
    const wallet = await Wallet.findOne({ userId: req.user.id });
    if (!wallet) {
      return res.status(404).json({ message: 'Wallet not found' });
    }
    res.json(wallet.balances);
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
};

exports.getDepositAddress = async (req, res) => {
  try {
    const { currency } = req.query;
    let wallet = await Wallet.findOne({ userId: req.user.id });
    if (!wallet) {
      wallet = new Wallet({ userId: req.user.id });
    }

    if (!wallet.depositAddresses[currency]) {
      wallet.depositAddresses[currency] = generateDepositAddress(currency);
    }

    await wallet.save();
    await sendNotification(req.user.id, 'New Deposit Address', `Your ${currency} address: ${wallet.depositAddresses[currency]}`);
    res.json({ address: wallet.depositAddresses[currency] });
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
};

exports.requestWithdrawal = async (req, res) => {
  try {
    const { currency, amount, address } = req.body;
    const wallet = await Wallet.findOne({ userId: req.user.id });

    if (!wallet || wallet.balances[currency.toLowerCase()] < amount) {
      return res.status(400).json({ success: false, message: 'Insufficient balance' });
    }

    const transaction = new Transaction({
      userId: req.user.id,
      type: 'withdraw',
      currency,
      amount,
      address,
    });

    await transaction.save();
    await sendNotification(req.user.id, 'Withdrawal Request', 'Your withdrawal is pending approval');
    res.json({ success: true, message: 'Withdrawal request submitted' });
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
};