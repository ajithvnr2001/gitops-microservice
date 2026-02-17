const express = require('express');
const app = express();
const port = process.env.PORT || 3000;
// Mock authentication endpoint
app.get('/', (req, res) => {
  res.send('Auth Service v1.0');
});
// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy' });
});

app.get('/login', (req, res) => {
  res.json({ message: 'Login Successful', user: 'admin' });
});

app.listen(port, () => {
  console.log(`Auth service listening   port ${port}`);
});