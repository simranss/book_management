// ignore_for_file: constant_identifier_names

class APIStrings {
static const String BASE_URL = 'http://localhost:8080';

  static const String LOGIN_API = '$BASE_URL/reader/login';
  static const String REGISTER_API = '$BASE_URL/reader/register';

  // book APIs
  static const String BOOKS_API = '$BASE_URL/books';
  static const String BOOK_API = '$BASE_URL/book';
  static const String BOOK_BY_ID_API = '$BOOK_API/id';
  static const String BOOKS_BY_AUTHOR_API = '$BOOKS_API/author';
  static const String BOOKS_BY_TITLE_API = '$BOOKS_API/title';

  // author APIs
  static const String AUTHORS_API = '$BASE_URL/authors';
  static const String AUTHOR_API = '$BASE_URL/author';
  static const String AUTHORS_BY_NAME_API = '$AUTHORS_API/name';
  static const String AUTHOR_BY_ID_API = '$AUTHOR_API/id';

  // keywords APIs
  static const String KEYWORDS_API = '$BASE_URL/keywords';
  static const String KEYWORDS_BY_BOOK_ID_API = '$KEYWORDS_API/book_id';
}
