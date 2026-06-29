import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:time_leak_flutter/core/dependencies/injection.dart';
import 'package:time_leak_flutter/feature/calendar_page/data/models/calendar_entry_model.dart';
import 'package:time_leak_flutter/feature/calendar_page/data/repository/synced_notes_repository.dart';
import 'package:time_leak_flutter/feature/calendar_page/presentation/widget/calendar_day_badge.dart';
import 'package:time_leak_flutter/feature/locale/cubit/locale_cubit.dart';
import 'package:time_leak_flutter/feature/notification/notification_service.dart';
import 'package:time_leak_flutter/l10n/app_localizations.dart';
import 'package:time_leak_flutter/l10n/calendar_default_note_title.dart';

class CalendarState {
  final DateTime selectedDate;
  final DateTime? clickedDate;
  final List<CalendarEntryModel> savedData;
  final bool isRecording;
  final String recordDuration;
  final String? message;
  final List<DateTime> markedDates;
  final List<CalendarEntryModel> monthEntries;
  final Set<int> yearsWithNotes;
  final Map<int, Color> yearBadgeColors;
  final bool hasNotesInPrevMonth;
  final bool hasNotesInNextMonth;
  final CalendarEntryModel? entryPendingReminder;

  CalendarState({
    required this.selectedDate,
    this.clickedDate,
    this.savedData = const [],
    this.isRecording = false,
    this.recordDuration = "00:00",
    this.message,
    this.markedDates = const [],
    this.monthEntries = const [],
    this.yearsWithNotes = const {},
    this.yearBadgeColors = const {},
    this.hasNotesInPrevMonth = false,
    this.hasNotesInNextMonth = false,
    this.entryPendingReminder,
  });

  CalendarState copyWith({
    DateTime? selectedDate,
    DateTime? clickedDate,
    List<CalendarEntryModel>? savedData,
    bool? isRecording,
    String? recordDuration,
    String? message,
    bool clearMessage = false,
    List<DateTime>? markedDates,
    List<CalendarEntryModel>? monthEntries,
    Set<int>? yearsWithNotes,
    Map<int, Color>? yearBadgeColors,
    bool? hasNotesInPrevMonth,
    bool? hasNotesInNextMonth,
    CalendarEntryModel? entryPendingReminder,
    bool clearPendingReminder = false,
  }) {
    return CalendarState(
      selectedDate: selectedDate ?? this.selectedDate,
      clickedDate: clickedDate ?? this.clickedDate,
      savedData: savedData ?? this.savedData,
      isRecording: isRecording ?? this.isRecording,
      recordDuration: recordDuration ?? this.recordDuration,
      message: clearMessage ? null : (message ?? this.message),
      markedDates: markedDates ?? this.markedDates,
      monthEntries: monthEntries ?? this.monthEntries,
      yearsWithNotes: yearsWithNotes ?? this.yearsWithNotes,
      yearBadgeColors: yearBadgeColors ?? this.yearBadgeColors,
      hasNotesInPrevMonth: hasNotesInPrevMonth ?? this.hasNotesInPrevMonth,
      hasNotesInNextMonth: hasNotesInNextMonth ?? this.hasNotesInNextMonth,
      entryPendingReminder: clearPendingReminder ? null : (entryPendingReminder ?? this.entryPendingReminder),
    );
  }
}

class CalendarCubit extends Cubit<CalendarState> {
  static const yearsAhead = 10;

  final _repo = sl<SyncedNotesRepository>();

  final ImagePicker _picker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();

  StreamSubscription? _dataSubscription;
  StreamSubscription? _markedDatesSubscription;
  StreamSubscription? _yearsSubscription;
  Timer? _recordTimer;
  int _recordSeconds = 0;

  CalendarCubit()
    : super(CalendarState(selectedDate: DateTime(DateTime.now().year, DateTime.now().month, 1))) {
    loadMarkedDates();
    _watchYearsWithNotes();
  }

  /// Синхронизация с бэком: подтянуть заметки в локальную БД (после переустановки/логина).
  Future<void> syncFromBackend() async {
    try {
      await _repo.syncFromBackend();
      loadMarkedDates();
    } catch (_) {}
  }

  // --- ЛОГИКА ИНДИКАТОРОВ (КРАСНЫЕ ТОЧКИ) ---
  static DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static bool _isPastDay(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    return day.isBefore(_today);
  }

  static List<CalendarEntryModel> _futureEntries(Iterable<CalendarEntryModel> entries) {
    return entries.where((e) => !_isPastDay(e.date)).toList();
  }

  void loadMarkedDates() {
    final startOfMonth = DateTime(state.selectedDate.year, state.selectedDate.month, 1);
    final endOfMonth = DateTime(state.selectedDate.year, state.selectedDate.month + 1, 0, 23, 59, 59);

    _markedDatesSubscription?.cancel();
    _markedDatesSubscription = _repo.watchCalendarsByRange(startOfMonth, endOfMonth).listen((entries) {
      final dates = entries.map((e) => DateTime(e.date.year, e.date.month, e.date.day)).toList();
      emit(state.copyWith(markedDates: dates, monthEntries: entries));
    });

    _loadAdjacentMonthsHints();
  }

  void _watchYearsWithNotes() {
    final startYear = DateTime.now().year;
    final start = DateTime(startYear, 1, 1);
    final end = DateTime(startYear + yearsAhead, 12, 31, 23, 59, 59);

    _yearsSubscription?.cancel();
    _yearsSubscription = _repo.watchCalendarsByRange(start, end).listen((entries) {
      final futureEntries = _futureEntries(entries);
      final byYear = <int, List<CalendarEntryModel>>{};
      for (final entry in futureEntries) {
        byYear.putIfAbsent(entry.date.year, () => []).add(entry);
      }
      final colors = <int, Color>{for (final year in byYear.keys) year: calendarDayBadgeColor(byYear[year]!)};
      if (!isClosed) {
        emit(state.copyWith(yearsWithNotes: byYear.keys.toSet(), yearBadgeColors: colors));
      }
    });
  }

  void _loadAdjacentMonthsHints() async {
    final current = state.selectedDate;
    final startOfCurrentMonth = DateTime(current.year, current.month, 1);
    final endOfPrevMonth = startOfCurrentMonth.subtract(const Duration(microseconds: 1));
    final startOfNextMonth = DateTime(current.year, current.month + 1, 1);
    final futureEnd = DateTime(2100, 12, 31, 23, 59, 59);

    try {
      final prevList = await _repo.getCalendarsByRange(DateTime(current.year, current.month - 1, 1), endOfPrevMonth);
      final futureList = await _repo.getCalendarsByRange(startOfNextMonth, futureEnd);
      if (!isClosed && state.selectedDate == current) {
        emit(
          state.copyWith(
            hasNotesInPrevMonth: _futureEntries(prevList).isNotEmpty,
            hasNotesInNextMonth: _futureEntries(futureList).isNotEmpty,
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
    emit(state.copyWith(clickedDate: cleanDate, clearPendingReminder: true));

    _dataSubscription?.cancel();
    _dataSubscription = _repo.watchCalendarsByDate(cleanDate).listen((models) {
      emit(state.copyWith(savedData: models));
    });
  }

  void clearPendingReminder() {
    emit(state.copyWith(clearPendingReminder: true));
  }

  void clearSelectedDate() {
    _dataSubscription?.cancel();
    emit(state.copyWith(
      clickedDate: null,
      savedData: const [],
      clearPendingReminder: true,
    ));
  }

  // --- РАБОТА С МЕДИА ---
  Future<void> pickImageFromCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) await saveEntry(photo.path, 'image');
  }

  Future<void> pickVideoFromCamera() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
    if (video != null) await saveEntry(video.path, 'video');
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
      final result = await _repo.putCalendar(
        pickedPath: pickedPath,
        type: type,
        date: state.clickedDate!,
        noteTitle: noteTitle,
      );
      final fileName = result.localPath.split('/').last;
      final dotIndex = fileName.lastIndexOf('.');
      final savedEntry = CalendarEntryModel(
        id: result.id,
        localPath: result.localPath,
        name: dotIndex > 0 ? fileName.substring(0, dotIndex) : fileName,
        extension: dotIndex > 0 ? fileName.substring(dotIndex + 1) : '',
        type: type,
        date: state.clickedDate!,
        title: noteTitle,
      );
      emit(state.copyWith(
        message: l10n.calendar_status_fileSaved,
        entryPendingReminder: savedEntry,
      ));
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
      emit(state.copyWith(message: l10n.calendar_status_fileDeleted));
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
      emit(state.copyWith(message: l10n.calendar_status_fileExportedToDownloads));
      _clearMessage();
    } catch (e) {
      emit(state.copyWith(message: l10n.calendar_status_exportError));
      _clearMessage();
    }
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
    _yearsSubscription?.cancel();
    _recordTimer?.cancel();
    _audioRecorder.dispose();
    return super.close();
  }
}
