const express = require('express');
const jwt = require('jsonwebtoken');
let users = require('./../data/usersdb.js');

const readerRouter = express.Router();

const userExists = (email) => {
    let validUsers = users.filter((user) => {
        return (user.email === email);
    });
    if (validUsers.length > 0) {
        return true;
    } else {
        return false;
    }
}

const authenticatedUser = (email, password) => {
    let validUsers = users.filter((user) => {
        return (user.email === email && user.password === password);
    });
    if (validUsers.length > 0) {
        return true;
    } else {
        return false;
    }
}

readerRouter.post('/login', (req, res) => {
    const email = req.body.email;
    const password = req.body.password;

    if (!email || !password) {
        return res.status(405).json({message: "email or password field empty"});
    }

    if (userExists(email)) {
        if (authenticatedUser(email, password)) {
            let accessToken = jwt.sign({
                data: password
            }, 'access', { expiresIn: 60 * 60 });

            req.session.authorization = {
                accessToken, email
            }
            return res.status(200).json({message: "User successfully logged in"});
        } else {
            return res.status(401).json({message: "Incorrect password"});
        }
    } else {
        return res.status(404).json({message: 'user does not exist'});
    }
});

readerRouter.post("/register", (req, res) => {
    const email = req.body.email;
    const password = req.body.password;
    const name = req.body.name;

    if (email && password) {
      if (!userExists(email)) {
        users.push({"name": name, "email": email, "password": password});
        return res.status(200).json({message: "User successfully registered. Now you can login"});
      } else {
        return res.status(404).json({message: "User already exists!"});
      }
    }
    return res.status(405).json({message: "Email or password field empty."});
});

module.exports.readerRouter = readerRouter;
