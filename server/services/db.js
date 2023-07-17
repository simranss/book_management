const mysql = require('mysql2/promise');
require("dotenv").config();

const mysql_pwd = process.env.MYSQL_PWD;
const mysql_username = process.env.MYSQL_USERNAME;
const mysql_host = process.env.MYSQL_HOST;
const mysql_db = process.env.MYSQL_DB;

async function query(sql, params) {
  const connection = await mysql.createConnection({
    host: mysql_host,
    user: mysql_username,
    password: mysql_pwd,
    database: mysql_db,
  });
  const [results, ] = await connection.execute(sql, params);

  return results;
}

module.exports = {
  query
}