const admin = require('firebase-admin');
const serviceAccount = require('./firebase-service-account.json');
// Ensure this path is correct

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});
