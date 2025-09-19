const mongoose = require('mongoose');

const contactSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  phone: String,
  address: String
});

module.exports = mongoose.model('Contact', contactSchema);
