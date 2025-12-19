console.log("🚀 VERCEL FUNCTION STARTING...");
console.log("BOT_TOKEN present:", !!process.env.BOT_TOKEN);
console.log("MONGODB_URI present:", !!process.env.MONGODB_URI);
const express = require('express');
const mongoose = require('mongoose');
const TelegramBot = require('node-telegram-bot-api');
const dotenv = require('dotenv');

dotenv.config();
const app = express();
app.use(express.json());

// MongoDB Connection
mongoose.connect(process.env.MONGODB_URI);

// Updated UserSchema with state tracking
const UserSchema = new mongoose.Schema({
  phone: { type: String, unique: true, sparse: true }, // sparse allows multiple nulls
  telegramId: String,
  chatId: String,
  name: String,
  gender: String,
  church: String,
  pin: String,
  otp: String,
  otpExpiry: Date,
  isRegistered: { type: Boolean, default: false },
  state: { type: String, default: 'START' }
});

const User = mongoose.model('User', UserSchema);

// Initialize Bot
const bot = new TelegramBot(process.env.BOT_TOKEN);

// --- TELEGRAM BOT WEBHOOK ---
app.post('/api/webhook', async (req, res) => {
  const { message } = req.body;
  if (!message) return res.sendStatus(200);

  const chatId = message.chat.id;
  const text = message.text;

  let user = await User.findOne({ chatId });

  // --- /start command ---
  if (text === '/start') {
    if (!user) {
      user = new User({ chatId, telegramId: message.from.id, state: 'WAITING_CONTACT' });
      await user.save();
    } else {
      user.state = 'WAITING_CONTACT';
      await user.save();
    }

    await bot.sendMessage(chatId, "Welcome to Vision for a Better Life! 🌟\n\nPlease share your contact number:", {
      reply_markup: {
        keyboard: [[{ text: "📱 Share Contact", request_contact: true }]],
        one_time_keyboard: true,
        resize_keyboard: true
      }
    });
    return res.sendStatus(200);
  }

  // --- Contact shared ---
  if (message.contact && user && user.state === 'WAITING_CONTACT') {
    const phone = message.contact.phone_number.replace(/\+/g, '');
    
    if (message.contact.user_id !== message.from.id) {
      await bot.sendMessage(chatId, "❌ Please share YOUR OWN contact number.");
      return res.sendStatus(200);
    }

    user.phone = phone;
    user.telegramId = message.from.id;
    user.isRegistered = true;
    user.state = 'WAITING_NAME';
    await user.save();

    await bot.sendMessage(chatId, "✅ Contact verified!\n\nWhat is your full name?", {
      reply_markup: { remove_keyboard: true }
    });
    return res.sendStatus(200);
  }

  // --- Name collection ---
  if (user && user.state === 'WAITING_NAME') {
    user.name = text;
    user.state = 'WAITING_GENDER';
    await user.save();

    await bot.sendMessage(chatId, "What is your gender?", {
      reply_markup: {
        keyboard: [['M', 'F']],
        one_time_keyboard: true,
        resize_keyboard: true
      }
    });
    return res.sendStatus(200);
  }

  // --- Gender collection ---
  if (user && user.state === 'WAITING_GENDER') {
    if (!['M', 'F', 'm', 'f'].includes(text)) {
      await bot.sendMessage(chatId, "❌ Please select 'M' or 'F'.");
      return res.sendStatus(200);
    }
    user.gender = text.toUpperCase();
    user.state = 'WAITING_CHURCH';
    await user.save();

    await bot.sendMessage(chatId, "Which church do you belong to?", {
      reply_markup: {
        keyboard: [
          ['MKC'],
          ['Mulu Wengel'],
          ['Kalehiywot'],
          ['Amanuel'],
          ['Other']
        ],
        one_time_keyboard: true,
        resize_keyboard: true
      }
    });
    return res.sendStatus(200);
  }

  // --- Church collection ---
  if (user && user.state === 'WAITING_CHURCH') {
    const validChurches = ['MKC', 'Mulu Wengel', 'Kalehiywot', 'Amanuel', 'Other'];
    
    if (text === 'Other') {
      user.state = 'WAITING_CUSTOM_CHURCH';
      await user.save();
      await bot.sendMessage(chatId, "Please type your church name:", {
        reply_markup: { remove_keyboard: true }
      });
      return res.sendStatus(200);
    }

    if (validChurches.includes(text)) {
      user.church = text;
      user.state = 'COMPLETED';
      await user.save();

      await bot.sendMessage(chatId, 
        `🎉 Registration completed!\n\n` +
        `Name: ${user.name}\n` +
        `Phone: +${user.phone}\n` +
        `Gender: ${user.gender}\n` +
        `Church: ${user.church}\n\n` +
        `You can now login via the Vision Loans mobile app! 📱`,
        { reply_markup: { remove_keyboard: true } }
      );
      return res.sendStatus(200);
    }

    await bot.sendMessage(chatId, "❌ Please select a valid church from the options.");
    return res.sendStatus(200);
  }

  // --- Custom church name ---
  if (user && user.state === 'WAITING_CUSTOM_CHURCH') {
    user.church = text;
    user.state = 'COMPLETED';
    await user.save();

    await bot.sendMessage(chatId, 
      `🎉 Registration completed!\n\n` +
      `Name: ${user.name}\n` +
      `Phone: +${user.phone}\n` +
      `Gender: ${user.gender}\n` +
      `Church: ${user.church}\n\n` +
      `You can now login via the Vision Loans mobile app! 📱`,
      { reply_markup: { remove_keyboard: true } }
    );
    return res.sendStatus(200);
  }

  res.sendStatus(200);
});

// --- MOBILE APP ENDPOINTS ---

app.post('/api/auth/check-phone', async (req, res) => {
  const { phone } = req.body;
  const user = await User.findOne({ phone, state: 'COMPLETED' });

  if (!user) {
    return res.status(404).json({ 
      message: "User not found. Please sign up first on Telegram (@VisionsLoansBot)" 
    });
  }

  const otp = Math.floor(100000 + Math.random() * 900000).toString();
  user.otp = otp;
  user.otpExpiry = new Date(Date.now() + 5 * 60000); // 5 minutes
  await user.save();

  await bot.sendMessage(user.chatId, 
    `🔐 Your Vision Loans login code is:\n\n` +
    `*${otp}*\n\n` +
    `This code expires in 5 minutes.`,
    { parse_mode: 'Markdown' }
  );

  res.json({ message: "OTP sent to your Telegram" });
});

app.post('/api/auth/verify-otp', async (req, res) => {
  const { phone, otp } = req.body;
  const user = await User.findOne({ 
    phone, 
    otp, 
    otpExpiry: { $gt: new Date() } 
  });

  if (!user) {
    return res.status(400).json({ message: "Invalid or expired OTP" });
  }

  user.otp = null;
  user.otpExpiry = null;
  await user.save();

  res.json({ 
    message: "Verified", 
    needsPin: !user.pin,
    user: { name: user.name, church: user.church }
  });
});

app.post('/api/auth/set-pin', async (req, res) => {
  const { phone, pin } = req.body;
  
  if (!/^\d{4}$/.test(pin)) {
    return res.status(400).json({ message: "PIN must be 4 digits" });
  }

  const user = await User.findOne({ phone });
  if (!user) {
    return res.status(404).json({ message: "User not found" });
  }

  // TODO: Hash the PIN in production (use bcrypt)
  user.pin = pin;
  await user.save();

  res.json({ message: "PIN set successfully" });
});

app.post('/api/auth/login-pin', async (req, res) => {
  const { phone, pin } = req.body;
  const user = await User.findOne({ phone, pin });
  
  if (!user) {
    return res.status(401).json({ message: "Invalid PIN" });
  }

  res.json({ 
    message: "Success", 
    user: { name: user.name, church: user.church, gender: user.gender } 
  });
});

module.exports = app;