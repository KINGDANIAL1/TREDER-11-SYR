 
const crypto = require('crypto');

const securityConfig = {
  jwtSecret: 'your_jwt_secret_key_here',
  encryptionKey: crypto.randomBytes(32),
  encryptionIV: crypto.randomBytes(16),
};

module.exports = securityConfig;