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
    try {
      await booksDB.insertBook(
        title,
        description,
        pages,
        authorId,
        releaseYear
      );
      return res.status(200).json({ message: "Book inserted successfully" });
    } catch (error) {
      console.log("error: ", error);
      return res.status(500).json({ message: "Internal Server Error" });
    }
  }
  res.status(405).json({ message: "One or more fields empty" });
});

bookRouter.get("/book/id/:id", async (req, res) => {
  const id = req.params.id;
  const book = await getBookById(id);
  if (book["id"]) {
    return res.status(200).send(book);
  }
  return res.status(404).json({ message: `No book found with id ${id}` });
});

bookRouter.get("/books/author/:author", async (req, res) => {
  const author = req.params.author;
  const books = await getBooksByAuthor(author);
  if (books.length > 0) {
    return res.status(200).send(books);
  }
  res.status(404).json({ message: `No books found with author ${author}.` });
});

bookRouter.get("/books/title/:title", async (req, res) => {
  const title = req.params.title;
  const books = await getBooksByTitle(title);
  if (books.length > 0) {
    return res.status(200).send(books);
  }
  res.status(404).json({ message: `No books found with title ${title}.` });
});

const getAuthorsByName = async (name) => {
  let authors = [];
  try {
    authors = await booksDB.getAuthorsByName(name);
    if (!authors) {
      authors = [];
    }
  } catch (error) {
    console.log("error: ", error);
  } finally {
    return authors;
  }
};

const getAuthorById = async (id) => {
  let author = {};
  try {
    let authors = await booksDB.getAuthorById(id);
    if (authors && authors.length > 0) {
      author = authors[0];
    }
    if (!author) {
      author = {};
    }
  } catch (error) {
    console.log("error: ", error);
  } finally {
    return author;
  }
};

bookRouter.get("/authors/name/:name", async (req, res) => {
  const name = req.params.name;
  const authors = await getAuthorsByName(name);
  if (authors.length > 0) {
    return res.status(200).send(authors);
  }
  res.status(404).json({ message: `No authors found with name ${name}.` });
});

bookRouter.get("/author/id/:id", async (req, res) => {
  const id = req.params.id;
  const author = await getAuthorById(id);
  if (author["id"]) {
    return res.status(200).send(author);
  }
  return res.status(404).json({ message: `No author found with id ${id}` });
});

module.exports = {
  bookRouter: bookRouter,
};
