 
const admin = require('../config/firebase');

exports.sendNotification = async (userId, title, body) => {
  try {
    const message = {
      notification: { title, body },
      topic: `user_${userId}`,
    };
    await admin.messaging().send(message);
    console.log(`Notification sent to user ${userId}`);
  } catch (error) {
    console.error('Error sending notification:', error);
  }
};