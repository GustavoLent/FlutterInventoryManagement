class Location {
  final String id;
  final String name;
  final String? parentId;

  Location({required this.id, required this.name, this.parentId});

  factory Location.fromJson(Map<String, dynamic> map) {
    return Location(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      parentId: map['parentId'],
    );
  }
}
