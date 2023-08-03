const db = require("./db");

async function getUserByEmailOrPhone(email, phone) {
  const row = await db.query(
    `select * from users where email=\"${email}\" or phone=\"${phone}\"`
  );
  console.log(row);
  return row;
}

const insertUser = async (name, email, phone, password) => {
  const result = await db.query(
    `insert into users (name, email, phone, password, verified) values (\"${name}\", \"${email}\", \"${phone}\", \"${password}\", 0);`
  );
  console.log(result);
  return result;
};

module.exports = {
  getUserByEmailOrPhone,
  insertUser,
};
