import 'dart:io';

import 'package:dio/dio.dart';
import 'package:time_leak_flutter/feature/core/data/model/note_model.dart';

/// Репозиторий заметок API: GET (список), POST (создать), PUT (обновить), DELETE (удалить).
class NotesRepository {
  final Dio _dio;

  NotesRepository(this._dio);

  static const String _path = '/api/v1/auth/notes';

  /// GET /api/v1/auth/notes — список заметок авторизованного пользователя.
  Future<NotesListResponse> getNotes() async {
    final response = await _dio.get(_path);
    return NotesListResponse.fromJson(response.data as Map<String, dynamic>);
  }

  /// POST /api/v1/auth/notes — создать заметку (note_type обязателен, files до 5 шт.).
  Future<NoteModel> createNote({
    required String noteType,
    List<String>? filePaths,
  }) async {
    final formData = FormData.fromMap({
      'note_type': noteType,
    });
    if (filePaths != null && filePaths.isNotEmpty) {
      for (final path in filePaths.take(5)) {
        formData.files.add(MapEntry('files', await MultipartFile.fromFile(path)));
      }
    }
    final response = await _dio.post(
      _path,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        headers: {'Accept': 'application/json'},
      ),
    );
    return NoteModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// PUT /api/v1/auth/notes/{id} — обновить заметку (note_type и/или files; files заменяют предыдущие).
  Future<NoteModel> updateNote({
    required String id,
    String? noteType,
    List<String>? filePaths,
  }) async {
    final formData = FormData();
    if (noteType != null) formData.fields.add(MapEntry('note_type', noteType));
    if (filePaths != null && filePaths.isNotEmpty) {
      for (final path in filePaths.take(5)) {
        formData.files.add(MapEntry('files', await MultipartFile.fromFile(path)));
      }
    }
    final response = await _dio.put(
      '$_path/$id',
      data: formData.fields.isNotEmpty || formData.files.isNotEmpty ? formData : null,
      options: Options(
        contentType: 'multipart/form-data',
        headers: {'Accept': 'application/json'},
      ),
    );
    return NoteModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// DELETE /api/v1/auth/notes/{id} — удалить заметку.
  Future<void> deleteNote(String id) async {
    await _dio.delete('$_path/$id');
  }

  /// Скачать файл по URL и сохранить по пути [savePath].
  Future<void> downloadToPath(String url, String savePath) async {
    final response = await _dio.get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    final data = response.data;
    if (data == null || data.isEmpty) return;
    await File(savePath).writeAsBytes(data);
  }
}
