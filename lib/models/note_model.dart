class Note {
  final int? id;
  String title;
  int color; // stored as int, not Color
  final String createdAt;
  final String updatedAt;

  Note({
    this.id,
    required this.title,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'color': color,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'] ?? '',
      color: map['color'] ?? 1,
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }
}
