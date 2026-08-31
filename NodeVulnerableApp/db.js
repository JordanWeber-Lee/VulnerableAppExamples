const mysql = require('mysql');
const config = require('./config');

const pool = mysql.createPool({
  connectionLimit: 10,
  host: config.db.host,
  port: config.db.port,
  user: config.db.user,
  password: config.db.password,
  database: config.db.database
});

function query(sql, callback) {
  pool.getConnection((err, connection) => {
    if (err) {
      return callback(err);
    }
    connection.query(sql, (queryErr, results) => {
      connection.release();
      callback(queryErr, results);
    });
  });
}

module.exports = {
  pool,
  query
};
