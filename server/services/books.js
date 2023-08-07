const db = require("./db");

const insertBook = async (title, desc, pages, author) => {
  const result = await db.query(
    `insert into books (title, description, pages, author) values (\"${title}\", \"${desc}\", ${pages}, \"${author}\");`
  );
  console.log(result);
  return result;
};

const getBookById = async (id) => {
  const row = await db.query(`select * from books where id=${id};`);
  console.log(row);
  return row;
};

const getBooksByAuthor = async (author) => {
  const rows = await db.query(
    `select * from books where author like \"%${author}%\" order by release_year desc limit 50;`
  );
  console.log(rows);
  return rows;
};

const getBooksByTitle = async (title) => {
  const rows = await db.query(
    `select * from books where title like \"%${title}%\" order by release_year desc limit 50;`
  );
  console.log(rows);
  return rows;
};

const getLatestBooks = async () => {
  const rows = await db.query(
    `select books.id, books.title, books.description, books.pages, books.release_year, book_series.name as series_name, books.author from books left join book_series on books.book_series = book_series.id order by books.release_year desc limit 50;`
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
