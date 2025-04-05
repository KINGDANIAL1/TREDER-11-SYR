 
const crypto = require('crypto');

exports.generateDepositAddress = (currency) => {
  return `${currency.toLowerCase()}_${crypto.randomBytes(16).toString('hex')}`;
};