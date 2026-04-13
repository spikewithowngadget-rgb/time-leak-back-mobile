/// Модель заметки с API (GET/POST/PUT ответы).
class NoteModel {
  final String id;
  final String userId;
  final String noteType;
  final List<String> noteFiles;
  final DateTime createdAt;

  NoteModel({
    required this.id,
    required this.userId,
    required this.noteType,
    required this.noteFiles,
    required this.createdAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    final files = json['note_files'];
    return NoteModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      noteType: json['note_type'] as String,
      noteFiles: files != null
          ? List<String>.from((files as List).map((e) => e.toString()))
          : [],
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'note_type': noteType,
        'note_files': noteFiles,
        'createdAt': createdAt.toIso8601String(),
      };
}

/// Ответ GET /api/v1/auth/notes — список заметок.
class NotesListResponse {
  final List<NoteModel> data;
  final int total;

  NotesListResponse({required this.data, required this.total});

  factory NotesListResponse.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List<dynamic>?;
    return NotesListResponse(
      data: list != null
          ? list.map((e) => NoteModel.fromJson(e as Map<String, dynamic>)).toList()
          : [],
      total: json['total'] as int? ?? 0,
    );
  }
}
