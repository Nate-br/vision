// Add "state" field to UserSchema
const UserSchema = new mongoose.Schema({
  phone: { type: String, unique: true, required: true },
  telegramId: String,
  chatId: String,
  name: String,
  gender: String, // M or F
  church: String,
  pin: String, // Hashed 4-digit PIN
  otp: String,
  otpExpiry: Date,
  isRegistered: { type: Boolean, default: false },
  state: { type: String, default: 'START' } // NEW: track user step
});

// TELEGRAM BOT LOGIC
app.post('/api/webhook', async (req, res) => {
  const { message } = req.body;
  if (!message) return res.sendStatus(200);

  const chatId = message.chat.id;
  const text = message.text;

  // Fetch user by chatId
  let user = await User.findOne({ chatId });

  // --- Start command ---
  if (text === '/start') {
    if (!user) {
      user = new User({ chatId, telegramId: message.from.id, state: 'WAITING_CONTACT' });
      await user.save();
    } else {
      user.state = 'WAITING_CONTACT';
      await user.save();
    }

    await bot.sendMessage(chatId, "Welcome to Vision Loans! Please share your contact number:", {
      reply_markup: {
        keyboard: [[{ text: "Share Contact", request_contact: true }]],
        one_time_keyboard: true
      }
    });
    return res.sendStatus(200);
  }

  // --- Handle shared contact ---
  if (message.contact && user && user.state === 'WAITING_CONTACT') {
    const phone = message.contact.phone_number.replace('+', '');
    if (message.contact.user_id !== message.from.id) {
      return bot.sendMessage(chatId, "Please share your OWN contact number.");
    }

    user.phone = phone;
    user.telegramId = message.from.id;
    user.isRegistered = true;
    user.state = 'WAITING_NAME';
    await user.save();

    await bot.sendMessage(chatId, "Contact verified! What is your full name?");
    return res.sendStatus(200);
  }

  // --- Collect Name ---
  if (user && user.state === 'WAITING_NAME') {
    user.name = text;
    user.state = 'WAITING_GENDER';
    await user.save();

    await bot.sendMessage(chatId, "What is your gender?", {
      reply_markup: {
        keyboard: [['M', 'F']],
        one_time_keyboard: true
      }
    });
    return res.sendStatus(200);
  }

  // --- Collect Gender ---
  if (user && user.state === 'WAITING_GENDER') {
    if (!['M', 'F'].includes(text)) {
      return bot.sendMessage(chatId, "Please select 'M' or 'F'.");
    }
    user.gender = text;
    user.state = 'WAITING_CHURCH';
    await user.save();

    await bot.sendMessage(chatId, "Which church do you belong to?");
    return res.sendStatus(200);
  }

  // --- Collect Church ---
  if (user && user.state === 'WAITING_CHURCH') {
    user.church = text;
    user.state = 'COMPLETED';
    await user.save();

    await bot.sendMessage(chatId, "Registration completed! You can now login via the mobile app.");
    return res.sendStatus(200);
  }

  res.sendStatus(200);
});
