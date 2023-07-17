const express = require("express");
const jwt = require("jsonwebtoken");
const usersDB = require("../services/users");

const readerRouter = express.Router();

const userByEmailOrPhone = async (email, phone) => {
  let validUsers = [];
  try {
    validUsers = await usersDB.getUserByEmailOrPhone(email, phone);
    if (validUsers) {
      return validUsers;
    } else {
      return [];
    }
  } catch (error) {
    console.log("error: ", error);
  } finally {
    return validUsers;
  }
};

readerRouter.post("/login", async (req, res) => {
  const email = req.body.email;
  const password = req.body.password;

  if (!email || !password) {
    return res.status(405).json({ message: "email or password field empty" });
  }

  let validUsers = await userByEmailOrPhone(email, "");

  if (validUsers.length > 0) {
    let validUser = validUsers[0];
    let validPassword = validUser["password"];
    if (validPassword.toString().trim() === password.toString().trim()) {
      let accessToken = jwt.sign(
        {
          data: password,
        },
        "access",
        { expiresIn: 60 * 60 }
      );

      req.session.authorization = {
        accessToken,
        email,
      };
      return res.status(200).json({ message: "User successfully logged in" });
    } else {
      return res.status(401).json({ message: "Incorrect password" });
    }
  } else {
    return res.status(404).json({ message: "user does not exist" });
  }
});

readerRouter.post("/register", async (req, res) => {
  const email = req.body.email;
  const password = req.body.password;
  const name = req.body.name;
  const phone = req.body.phone;

  if (email) {
    if (name) {
      if (phone) {
        if (password) {
          let validUsers = await userByEmailOrPhone(email, phone);
          if (validUsers.length === 0) {
            try {
              await usersDB.insertUser(name, email, phone, password);
              return res.status(200).json({
                message: "User successfully registered. Now you can login",
              });
            } catch (error) {
              console.log("error: ", error);
              return res.status(500).json({ message: "Internal Server Error" });
            }
          } else {
            return res.status(404).json({ message: "User already exists!" });
          }
        } else {
          return res.status(405).json({ message: "Password required." });
        }
      } else {
        return res.status(405).json({ message: "Phone required." });
      }
    } else {
      return res.status(405).json({ message: "Name required." });
    }
  } else {
    return res.status(405).json({ message: "Email required." });
  }
  return res.status(500).json({ message: "Internal Server Error" });
});

module.exports.readerRouter = readerRouter;
