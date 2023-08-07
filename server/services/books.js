const db = require("./db");

const insertBook = async (title, desc, pages, authorId, releaseYear) => {
  const result = await db.query(
    `insert into books (title, description, pages, author, release_year) values (\"${title}\", \"${desc}\", ${pages}, ${authorId}, ${releaseYear});`
  );
  console.log(result);
  return result;
};

const getBookById = async (id) => {
  const row = await db.query(
    `select books.id, books.title, books.description, books.pages, books.release_year, book_series.name as series_name, authors.name as author, books.book_series as series_id, books.author as author_id from books left join book_series on books.book_series = book_series.id left join authors on books.author = authors.id where books.id=${id};`
  );
  console.log(row);
  return row;
};

const getBooksByAuthor = async (author) => {
  const rows = await db.query(
    `select books.id, books.title, books.description, books.pages, books.release_year, book_series.name as series_name, authors.name as author, books.book_series as series_id, books.author as author_id from books left join book_series on books.book_series = book_series.id left join authors on books.author = authors.id where authors.name like \"%${author}%\" order by books.release_year desc limit 50;`
  );
  console.log(rows);
  return rows;
};

const getBooksByTitle = async (title) => {
  const rows = await db.query(
    `select books.id, books.title, books.description, books.pages, books.release_year, book_series.name as series_name, authors.name as author, books.book_series as series_id, books.author as author_id from books left join book_series on books.book_series = book_series.id left join authors on books.author = authors.id where books.title like \"%${title}%\" order by books.release_year desc limit 50;`
  );
  console.log(rows);
  return rows;
};

const getLatestBooks = async () => {
  const rows = await db.query(
    `select books.id, books.title, books.description, books.pages, books.release_year, book_series.name as series_name, authors.name as author, books.book_series as series_id, books.author as author_id from books left join book_series on books.book_series = book_series.id left join authors on books.author = authors.id order by books release_year desc limit 50;`
  );
  console.log(rows);
  return rows;
};

module.exports = {
  insertBook,
  getBookById,
  getBooksByAuthor,
  getBooksByTitle,
  getLatestBooks,
};
