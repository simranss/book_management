class Author {
  final String name, description;
  final int id;
  final String? website;

  const Author(
    this.id,
    this.name, {
    required this.description,
    required this.website,
  });

  static Author fromMap(Map<String, dynamic> map) {
    return Author(
      map['id'],
      map['name'],
      description: map['description'],
      website: map['website'],
    );
  }
}
