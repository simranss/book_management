// ignore_for_file: constant_identifier_names

class APIStrings {
  static const String BASE_URL = 'http://localhost:8080';

  static const String LOGIN_API = '$BASE_URL/reader/login';
  static const String REGISTER_API = '$BASE_URL/reader/register';

  // books APIs
  static const String BOOKS_API = '$BASE_URL/books';
  static const String BOOK_BY_ID_API = '$BASE_URL/book/id';
  static const String BOOKS_BY_AUTHOR_API = '$BOOKS_API/author';
  static const String BOOKS_BY_TITLE_API = '$BOOKS_API/title';
}
