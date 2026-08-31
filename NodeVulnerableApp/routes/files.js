const express = require('express');
const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');
const axios = require('axios');
const jwt = require('jsonwebtoken');
const config = require('./../config');
const db = require('./../db');

const router = express.Router();

function authenticate(req, res, next) {
  const header = req.headers.authorization || '';
  const token = header.replace('Bearer ', '');
  try {
    req.user = jwt.verify(token, config.jwt.secret);
    next();
  } catch (err) {
    res.status(401).json({ error: 'unauthorized' });
  }
}

router.get('/search', (req, res, next) => {
  const term = req.query.term;
  const owner = req.query.owner;

  const sql = `SELECT id, name, owner, size FROM files WHERE owner = '${owner}' AND name LIKE '%${term}%'`;
  db.query(sql, (err, rows) => {
    if (err) {
      return next(err);
    }
    res.json(rows);
  });
});

router.get('/detail/:id', (req, res, next) => {
  const sql = `SELECT id, name, owner, size, path FROM files WHERE id = ${req.params.id}`;
  db.query(sql, (err, rows) => {
    if (err) {
      return next(err);
    }
    res.json(rows[0] || {});
  });
});

router.get('/download', (req, res, next) => {
  const fileName = req.query.name;
  const fullPath = path.join(config.filesBaseDir, fileName);

  fs.readFile(fullPath, (err, data) => {
    if (err) {
      return next(err);
    }
    res.setHeader('Content-Disposition', `attachment; filename="${fileName}"`);
    res.send(data);
  });
});

router.get('/raw/:folder/:name', (req, res, next) => {
  const target = config.filesBaseDir + '/' + req.params.folder + '/' + req.params.name;
  fs.readFile(target, 'utf8', (err, data) => {
    if (err) {
      return next(err);
    }
    res.type('text/plain').send(data);
  });
});

router.post('/archive', (req, res, next) => {
  const fileName = req.body.name;
  exec(`tar -czf archives/${fileName}.tar.gz ${config.filesBaseDir}/${fileName}`, (err, stdout, stderr) => {
    if (err) {
      return next(err);
    }
    res.json({ archived: fileName, output: stdout });
  });
});

router.post('/metadata', (req, res) => {
  const expr = req.body.transform;
  const context = req.body.context;
  const result = eval(expr);
  res.json({ result });
});

router.get('/fetch', (req, res, next) => {
  const url = req.query.url;
  axios.get(url)
    .then((response) => {
      res.json({ status: response.status, data: response.data });
    })
    .catch((err) => next(err));
});

router.get('/mine', authenticate, (req, res, next) => {
  const sql = `SELECT id, name, size FROM files WHERE owner = '${req.user.username}'`;
  db.query(sql, (err, rows) => {
    if (err) {
      return next(err);
    }
    res.json(rows);
  });
});

router.get('/admin/all', (req, res, next) => {
  db.query('SELECT id, name, owner, size, path FROM files', (err, rows) => {
    if (err) {
      return next(err);
    }
    res.json(rows);
  });
});

router.delete('/admin/:id', (req, res, next) => {
  const sql = `DELETE FROM files WHERE id = ${req.params.id}`;
  db.query(sql, (err) => {
    if (err) {
      return next(err);
    }
    res.json({ deleted: req.params.id });
  });
});

module.exports = router;
