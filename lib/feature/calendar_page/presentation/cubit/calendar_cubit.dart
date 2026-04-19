import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:time_leak_flutter/core/dependencies/injection.dart';
import 'package:time_leak_flutter/feature/calendar_page/data/models/calendar_entry_model.dart';
import 'package:time_leak_flutter/feature/calendar_page/data/repository/synced_notes_repository.dart';
import 'package:time_leak_flutter/feature/locale/cubit/locale_cubit.dart';
import 'package:time_leak_flutter/feature/notification/notification_service.dart';
import 'package:time_leak_flutter/l10n/app_localizations.dart';
import 'package:time_leak_flutter/l10n/calendar_default_note_title.dart';

class CalendarState {
  final DateTime selectedDate;
  final DateTime? clickedDate;
  final List<CalendarEntryModel> savedData;
  final String? activeEntryPath;
  final bool isRecording;
  final String recordDuration;
  final String? message;
  final List<DateTime> markedDates;
  final bool hasNotesInPrevMonth;
  final bool hasNotesInNextMonth;

  CalendarState({
    required this.selectedDate,
    this.clickedDate,
    this.savedData = const [],
    this.activeEntryPath,
    this.isRecording = false,
    this.recordDuration = "00:00",
    this.message,
    this.markedDates = const [],
    this.hasNotesInPrevMonth = false,
    this.hasNotesInNextMonth = false,
  });

  CalendarState copyWith({
    DateTime? selectedDate,
    DateTime? clickedDate,
    List<CalendarEntryModel>? savedData,
    String? activeEntryPath,
    bool? isRecording,
    String? recordDuration,
    String? message,
    bool clearActivePath = false,
    bool clearMessage = false,
    List<DateTime>? markedDates,
    bool? hasNotesInPrevMonth,
    bool? hasNotesInNextMonth,
  }) {
    return CalendarState(
      selectedDate: selectedDate ?? this.selectedDate,
      clickedDate: clickedDate ?? this.clickedDate,
      savedData: savedData ?? this.savedData,
      activeEntryPath: clearActivePath ? null : (activeEntryPath ?? this.activeEntryPath),
      isRecording: isRecording ?? this.isRecording,
      recordDuration: recordDuration ?? this.recordDuration,
      message: clearMessage ? null : (message ?? this.message),
      markedDates: markedDates ?? this.markedDates,
      hasNotesInPrevMonth: hasNotesInPrevMonth ?? this.hasNotesInPrevMonth,
      hasNotesInNextMonth: hasNotesInNextMonth ?? this.hasNotesInNextMonth,
    );
  }
}

class CalendarCubit extends Cubit<CalendarState> {
  final _repo = sl<SyncedNotesRepository>();

  final ImagePicker _picker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();

  StreamSubscription? _dataSubscription;
  StreamSubscription? _markedDatesSubscription;
  Timer? _recordTimer;
  int _recordSeconds = 0;

  CalendarCubit()
    : super(CalendarState(selectedDate: DateTime(DateTime.now().year, DateTime.now().month, 1))) {
    loadMarkedDates();
  }

  /// Синхронизация с бэком: подтянуть заметки в локальную БД (после переустановки/логина).
  Future<void> syncFromBackend() async {
    try {
      await _repo.syncFromBackend();
      loadMarkedDates();
    } catch (_) {}
  }

  // --- ЛОГИКА ИНДИКАТОРОВ (КРАСНЫЕ ТОЧКИ) ---
  void loadMarkedDates() {
    final startOfMonth = DateTime(state.selectedDate.year, state.selectedDate.month, 1);
    final endOfMonth = DateTime(state.selectedDate.year, state.selectedDate.month + 1, 0, 23, 59, 59);

    _markedDatesSubscription?.cancel();
    _markedDatesSubscription = _repo.watchCalendarsByRange(startOfMonth, endOfMonth).listen((entries) {
      final dates = entries.map((e) => DateTime(e.date.year, e.date.month, e.date.day)).toList();
      emit(state.copyWith(markedDates: dates));
    });

    _loadAdjacentMonthsHints();
  }

  void _loadAdjacentMonthsHints() async {
    final current = state.selectedDate;
    final startOfCurrentMonth = DateTime(current.year, current.month, 1);
    final endOfPrevMonth = startOfCurrentMonth.subtract(const Duration(microseconds: 1));
    final startOfNextMonth = DateTime(current.year, current.month + 1, 1);

    final pastStart = DateTime(2000, 1, 1);
    final futureEnd = DateTime(2100, 12, 31, 23, 59, 59);

    try {
      final pastList = await _repo.getCalendarsByRange(pastStart, endOfPrevMonth);
      final futureList = await _repo.getCalendarsByRange(startOfNextMonth, futureEnd);
      if (!isClosed && state.selectedDate == current) {
        emit(
          state.copyWith(
            hasNotesInPrevMonth: pastList.isNotEmpty,
            hasNotesInNextMonth: futureList.isNotEmpty,
          ),
        );
      }
    } catch (_) {}
  }

  // --- НАВИГАЦИЯ ---
  void selectYear(int year) {
    emit(state.copyWith(selectedDate: DateTime(year, state.selectedDate.month, 1)));
    loadMarkedDates();
  }

  void nextMonth() {
    emit(state.copyWith(selectedDate: DateTime(state.selectedDate.year, state.selectedDate.month + 1, 1)));
    loadMarkedDates();
  }

  void prevMonth() {
    emit(state.copyWith(selectedDate: DateTime(state.selectedDate.year, state.selectedDate.month - 1, 1)));
    loadMarkedDates();
  }

  void clickDate(DateTime date) {
    final cleanDate = DateTime(date.year, date.month, date.day);
    emit(state.copyWith(clickedDate: cleanDate));

    _dataSubscription?.cancel();
    _dataSubscription = _repo.watchCalendarsByDate(cleanDate).listen((models) {
      emit(state.copyWith(savedData: models));
    });
  }

  // --- РАБОТА С МЕДИА ---
  Future<void> pickImageFromCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) await saveEntry(photo.path, 'image');
  }

  Future<void> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) await saveEntry(image.path, 'image');
  }

  Future<void> pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result?.files.single.path != null) {
      await saveEntry(result!.files.single.path!, 'doc');
    }
  }

  Future<void> saveEntry(String pickedPath, String type) async {
    if (state.clickedDate == null) return;
    final l10n = lookupAppLocalizations(sl<LocaleCubit>().state);
    try {
      final noteTitle = calendarDefaultNoteTitle(l10n, state.clickedDate!);
      final entryId = await _repo.putCalendar(
        pickedPath: pickedPath,
        type: type,
        date: state.clickedDate!,
        noteTitle: noteTitle,
      );
      // По умолчанию — напоминание «каждый день» (через 24 ч)
      const defaultReminderMinutes = 24 * 60; // 1440
      final notificationService = sl<NotificationService>();
      await notificationService.scheduleFlexibleNotification(
        id: entryId,
        title: noteTitle,
        body: l10n.calendar_reminderNotificationBody,
        totalMinutes: defaultReminderMinutes,
      );
      await _repo.updateReminder(entryId, defaultReminderMinutes);
      emit(state.copyWith(message: l10n.calendar_status_fileSaved));
      _clearMessage();
    } catch (e) {
      emit(state.copyWith(message: l10n.calendar_status_saveError));
      _clearMessage();
    }
  }

  // --- ЗАПИСЬ АУДИО ---
  Future<void> startRecording() async {
    if (await Permission.microphone.request().isGranted) {
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/temp_record_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _audioRecorder.start(const RecordConfig(), path: path);
      _recordSeconds = 0;
      emit(state.copyWith(isRecording: true, recordDuration: "00:00"));

      _recordTimer?.cancel();
      _recordTimer = Timer.periodic(const Duration(seconds: 1), (t) {
        _recordSeconds++;
        emit(state.copyWith(recordDuration: _formatSeconds(_recordSeconds)));
      });
    }
  }

  Future<void> stopRecording() async {
    final path = await _audioRecorder.stop();
    _recordTimer?.cancel();
    emit(state.copyWith(isRecording: false));
    if (path != null) await saveEntry(path, 'audio');
  }

  // --- УДАЛЕНИЕ И ЭКСПОРТ ---
  Future<void> deleteEntry(CalendarEntryModel model) async {
    final l10n = lookupAppLocalizations(sl<LocaleCubit>().state);
    try {
      await sl<NotificationService>().cancelNotification(model.id);
      await _repo.deleteCalendar(model);
      emit(state.copyWith(clearActivePath: true, message: l10n.calendar_status_fileDeleted));
      _clearMessage();
    } catch (e) {
      emit(state.copyWith(message: l10n.calendar_status_deleteError));
      _clearMessage();
    }
  }

  Future<void> downloadEntry(CalendarEntryModel model) async {
    final l10n = lookupAppLocalizations(sl<LocaleCubit>().state);
    try {
      await _repo.downloadCalendar(model);
      emit(state.copyWith(clearActivePath: true, message: l10n.calendar_status_fileExportedToDownloads));
      _clearMessage();
    } catch (e) {
      emit(state.copyWith(message: l10n.calendar_status_exportError));
      _clearMessage();
    }
  }

  void toggleEntryMenu(String path) {
    state.activeEntryPath == path
        ? emit(state.copyWith(clearActivePath: true))
        : emit(state.copyWith(activeEntryPath: path));
  }

  /// Обновить заголовок заметки.
  Future<void> updateEntryTitle(CalendarEntryModel entry, String title) async {
    try {
      await _repo.updateCalendar(entry, title: title.trim().isEmpty ? null : title.trim());
    } catch (_) {}
  }

  void _clearMessage() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!isClosed) emit(state.copyWith(clearMessage: true));
    });
  }

  String _formatSeconds(int s) =>
      "${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}";

  @override
  Future<void> close() {
    _dataSubscription?.cancel();
    _markedDatesSubscription?.cancel();
    _recordTimer?.cancel();
    _audioRecorder.dispose();
    return super.close();
  }
}
