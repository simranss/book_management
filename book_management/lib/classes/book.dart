class Book {
  final int id, pages, releaseYear;
  final String title, description, author;
  final String? bookSeries;

  const Book(
    this.id,
    this.title, {
    required this.description,
    required this.author,
    required this.pages,
    required this.releaseYear,
    required this.bookSeries,
  });

  static Book fromMap(Map<String, dynamic> map) {
    return Book(
      map['id'],
      map['title'],
      description: map['description'],
      author: map['author'],
      pages: map['pages'],
      releaseYear: map['release_year'],
      bookSeries: map['series_name'],
    );
  }
}
