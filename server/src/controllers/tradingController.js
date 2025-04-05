 
const Wallet = require('../models/Wallet');

exports.getMarketData = async (req, res) => {
  try {
    const { pair } = req.query;
    const mockData = {
      'BTC/USDT': { price: 50000, volume: 1000 },
      'ETH/USDT': { price: 3000, volume: 500 },
      'BTC/ETH': { price: 16.67, volume: 200 },
    };
    res.json(mockData[pair] || { price: 0, volume: 0 });
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
};

exports.placeOrder = async (req, res) => {
  try {
    const { pair, type, amount } = req.body;
    const wallet = await Wallet.findOne({ userId: req.user.id });
    const [base, quote] = pair.split('/');

    const price = 50000; // سعر افتراضي، يمكن استبداله بـAPI خارجي
    if (type === 'buy') {
      if (wallet.balances[quote.toLowerCase()] < amount * price) {
        return res.status(400).json({ success: false, message: 'Insufficient balance' });
      }
      wallet.balances[quote.toLowerCase()] -= amount * price;
      wallet.balances[base.toLowerCase()] += parseFloat(amount);
    } else {
      if (wallet.balances[base.toLowerCase()] < amount) {
        return res.status(400).json({ success: false, message: 'Insufficient balance' });
      }
      wallet.balances[base.toLowerCase()] -= parseFloat(amount);
      wallet.balances[quote.toLowerCase()] += amount * price;
    }

    wallet.updatedAt = Date.now();
    await wallet.save();
    res.json({ success: true, message: 'Order placed' });
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
};