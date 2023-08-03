const express = require("express");
const readerRouter = require("./routers/reader_router.js").readerRouter;
const bookRouter = require("./routers/book_router.js").bookRouter;
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

const PORT = process.env.PORT;

app.use("/reader", readerRouter);
app.use("/", bookRouter);

app.get("/", (req, res) => {
  res.status(200).json({ message: "All good" });
});

app.listen(PORT, () => {
  console.log("Server is running on port", PORT);
});
