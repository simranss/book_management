const express = require("express");
const booksDB = require("../services/books");

const bookRouter = express.Router();

const getBooks = async () => {
  let books = [];
  try {
    books = await booksDB.getLatestBooks();
    if (!books) {
      books = [];
    }
  } catch (error) {
    console.log("error: ", error);
  } finally {
    return books;
  }
};

const getBookById = async (id) => {
  let book = {};
  try {
    let books = await booksDB.getBookById(id);
    if (books && books.length > 0) {
      book = books[0];
    }
    if (!book) {
      book = {};
    }
  } catch (error) {
    console.log("error: ", error);
  } finally {
    return book;
  }
};

const getBooksByAuthor = async (author) => {
  let books = [];
  try {
    books = await booksDB.getBooksByAuthor(author);
    if (!books) {
      books = [];
    }
  } catch (error) {
    console.log("error: ", error);
  } finally {
    return books;
  }
};

const getBooksByTitle = async (title) => {
  let books = [];
  try {
    books = await booksDB.getBooksByTitle(title);
    if (!books) {
      books = [];
    }
  } catch (error) {
    console.log("error: ", error);
  } finally {
    return books;
  }
};

const insertBook = async (title, description, author, pages, releaseYear) => {
  try {
    await booksDB.insertBook(title, description, pages, author, releaseYear);
  } catch (error) {
    console.log("error: ", error);
  }
};

bookRouter.get("/books", async (req, res) => {
  const books = await getBooks();
  if (books.length > 0) {
    return res.status(200).send(books);
  }
  res.status(404).json({ message: "No books found." });
});

bookRouter.post("/book", async (req, res) => {
  const title = req.body.title;
  const description = req.body.description;
  const authorId = req.body.author_id;
  const pages = req.body.pages;
  const releaseYear = req.body.release_year;

  if (title && description && authorId && pages && releaseYear) {
    await insertBook(title, description, authorId, pages, releaseYear);
    return res.status(200).json({ message: "Book inserted successfully" });
  }
  res.status(405).json({ message: "One or more fields empty" });
});

bookRouter.get("/book/id/:id", async (req, res) => {
  const id = req.params.id;
  const book = await getBookById(id);
  if (book["id"]) {
    return res.status(200).send(book);
  }
  return res.status(404).json({ message: `No book with id ${id}` });
});

bookRouter.get("/books/author/:author", async (req, res) => {
  const author = req.params.author;
  const books = await getBooksByAuthor(author);
  if (books.length > 0) {
    return res.status(200).send(books);
  }
  res.status(404).json({ message: "No books found." });
});

bookRouter.get("/books/title/:title", async (req, res) => {
  const title = req.params.title;
  const books = await getBooksByTitle(title);
  if (books.length > 0) {
    return res.status(200).send(books);
  }
  res.status(404).json({ message: "No books found." });
});

module.exports = {
  bookRouter: bookRouter,
};
