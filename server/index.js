const express = require("express");
const jwt = require("jsonwebtoken");
const session = require("express-session");
const readerRouter = require("./routers/reader_router.js").readerRouter;
require("dotenv").config();
const cors = require("cors");

const app = express();

app.use(express.json());
app.use(
  express.urlencoded({
    extended: true,
  })
);
app.use(cors());

app.use(
  "/reader/book",
  session({ secret: "book_reader", resave: true, saveUninitialized: true })
);

app.use("/reader/book/*", function auth(req, res, next) {
  if (req.session.authorization) {
    let token = req.session.authorization["accessToken"]; // Access Token

    jwt.verify(token, "access", (err, user) => {
      if (!err) {
        req.user = user;
        next();
      } else {
        return res.status(403).json({ message: "User not authenticated" });
      }
    });
  } else {
    return res.status(402).json({ message: "User not logged in" });
  }
});

const PORT = process.env.PORT;

app.use("/reader", readerRouter);

app.get("/", (req, res) => {
  res.status(200).json({ message: "ok" });
});

app.listen(PORT, () => {
  console.log("Server is running on port", PORT);
});
