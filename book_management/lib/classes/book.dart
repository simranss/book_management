class Book {
  final int id, pages, releaseYear;
  final String title, description, author;
  final int? bookSeriesId;

  const Book(
    this.id,
    this.title, {
    required this.description,
    required this.author,
    required this.pages,
    required this.releaseYear,
    required this.bookSeriesId,
  });

  static Book fromMap(Map<String, dynamic> map) {
    return Book(
      map['id'],
      map['title'],
      description: map['description'],
      author: map['author'],
      pages: map['pages'],
      releaseYear: map['release_year'],
      bookSeriesId: map['book_series'],
    );
  }
}
