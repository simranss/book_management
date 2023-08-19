class Keyword {
  final int id;
  final String keyword;

  const Keyword(this.id, {required this.keyword});

  static Keyword fromMap(Map<String, dynamic> map) {
    return Keyword(map['keyword_id'] as int, keyword: map['keyword'] as String);
  }
}
