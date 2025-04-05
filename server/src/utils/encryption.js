 
const crypto = require('crypto');
const { encryptionKey, encryptionIV } = require('../config/security');

const algorithm = 'aes-256-cbc';

exports.encrypt = (text) => {
  const cipher = crypto.createCipheriv(algorithm, encryptionKey, encryptionIV);
  let encrypted = cipher.update(text, 'utf8', 'hex');
  encrypted += cipher.final('hex');
  return encrypted;
};

exports.decrypt = (encrypted) => {
  const decipher = crypto.createDecipheriv(algorithm, encryptionKey, encryptionIV);
  let decrypted = decipher.update(encrypted, 'hex', 'utf8');
  decrypted += decipher.final('utf8');
  return decrypted;
};