require('dotenv').config();
const express = require('express');
const cors = require('cors');
const connectDB = require('./src/services/connectService');

const authRoutes = require('./src/routes/auth');
const contactRoutes = require('./src/routes/contact');

const app = express();

app.use(cors());
app.use(express.json());

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/contact', contactRoutes);

const PORT = process.env.PORT || 5000;

connectDB().then(() => {
  app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
});
