const express = require('express');
const Contact = require('../models/contact');
const { authMiddleware, roleMiddleware } = require('../middleware/authMiddleware');

const router = express.Router();

// Get all contacts (admin only)
router.get('/', authMiddleware, roleMiddleware(['admin']), async (req, res) => {
  const contacts = await Contact.find().populate('user', 'username email role');
  res.json(contacts);
});

// Get my contact
router.get('/me', authMiddleware, async (req, res) => {
  const contact = await Contact.findOne({ user: req.user._id });
  res.json(contact);
});

// Create or update my contact
router.post('/me', authMiddleware, async (req, res) => {
  let contact = await Contact.findOne({ user: req.user._id });
  if (contact) {
    contact.phone = req.body.phone;
    contact.address = req.body.address;
    await contact.save();
    return res.json(contact);
  }
  contact = new Contact({ user: req.user._id, phone: req.body.phone, address: req.body.address });
  await contact.save();
  res.status(201).json(contact);
});

// Delete my contact (admin or self)
router.delete('/me', authMiddleware, async (req, res) => {
  const contact = await Contact.findOneAndDelete({ user: req.user._id });
  if (!contact) return res.status(404).json({ message: 'Contact not found' });
  res.json({ message: 'Contact deleted' });
});

module.exports = router;
