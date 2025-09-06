class Note {
  final int? id;
  String title;
  String body;
  int color; // stored as int, not Color
  final String createdAt;
  final String updatedAt;

  Note({
    this.id,
    required this.title,
    required this.body,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to map for DB
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'color': color,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Convert from DB row
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      color: map['color'] ?? 1,
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }
}
