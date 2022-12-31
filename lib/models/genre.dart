class Genre {
  final int id;
  final String name;

  Genre({
    required this.id,
    required this.name,
  });

  factory Genre.fromJson(dynamic json) {
    return Genre(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}
