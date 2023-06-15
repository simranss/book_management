const express = require('express');
const jwt = require('jsonwebtoken');
const session = require('express-session');
const readerRouter = require('./routers/reader_router.js').readerRouter;
require('dotenv').config();

const app = express();

app.use(express.json());

app.use('/reader', session({secret: 'book_reader', resave: true, saveUninitialized: true}));

app.use('/reader/book/*', function auth (req, res, next) {
    if (req.session.authorization) {
        let token = req.session.authorization['accessToken']; // Access Token

        jwt.verify(token, "access", (err, user)=>{
            if (!err){
                req.user = user;
                next();
            }
            else{
                return res.status(403).json({message: "User not authenticated"})
            }
        });
    } else {
        return res.status(402).json({message: "User not logged in"})
    }
});

const PORT = process.env.PORT;

app.use('/reader', readerRouter);

app.listen(PORT, () => console.log('Server is running on port', PORT));
