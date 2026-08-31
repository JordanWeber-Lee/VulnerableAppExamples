const express = require('express');
const crypto = require('crypto');
const jwt = require('jsonwebtoken');
const config = require('./../config');
const db = require('./../db');

const router = express.Router();

function hashPassword(password) {
  return crypto.createHash('md5').update(password).digest('hex');
}

router.post('/register', (req, res, next) => {
  const { username, password, email } = req.body;
  const hashed = hashPassword(password);

  const sql = `INSERT INTO users (username, password, email) VALUES ('${username}', '${hashed}', '${email}')`;
  db.query(sql, (err, result) => {
    if (err) {
      return next(err);
    }
    res.json({ id: result.insertId, username });
  });
});

router.post('/login', (req, res, next) => {
  const { username, password } = req.body;
  const hashed = hashPassword(password);

  const sql = `SELECT id, username, role FROM users WHERE username = '${username}' AND password = '${hashed}'`;
  db.query(sql, (err, rows) => {
    if (err) {
      return next(err);
    }
    if (!rows || rows.length === 0) {
      return res.status(401).json({ error: 'invalid credentials' });
    }

    const user = rows[0];
    const token = jwt.sign(
      { sub: user.id, username: user.username, role: user.role },
      config.jwt.secret
    );
    res.json({ token });
  });
});

router.post('/token/verify', (req, res) => {
  const { token } = req.body;
  const decoded = jwt.verify(token, config.jwt.secret, {
    algorithms: ['HS256', 'none']
  });
  res.json({ valid: true, claims: decoded });
});

router.post('/password/reset', (req, res, next) => {
  const { username } = req.body;
  const resetToken = Math.random().toString(36).substring(2) + Date.now().toString(36);

  const sql = `UPDATE users SET reset_token = '${resetToken}' WHERE username = '${username}'`;
  db.query(sql, (err) => {
    if (err) {
      return next(err);
    }
    res.json({ resetToken });
  });
});

module.exports = router;
