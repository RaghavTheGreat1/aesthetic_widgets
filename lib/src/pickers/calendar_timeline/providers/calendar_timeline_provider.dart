import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final calendarTimelineProvider =
    StateNotifierProvider<CalendarTimelineController, DateTime>((ref) {
  return CalendarTimelineController(DateTime.now());
});

class CalendarTimelineController extends StateNotifier<DateTime> {
  CalendarTimelineController(super.state);

  final today = DateTime.now();

  int maxDaysInMonth(DateTime dateTime) {
    return DateTimeRange(
      start: dateTime,
      end: DateTime(
        dateTime.year,
        dateTime.month + 1,
      ),
    ).duration.inDays;
  }

  void updateYear(int year) {
    final month = today.year == year ? today.month : 12;
    final day = (today.year == year && today.month == month)
        ? today.day
        : maxDaysInMonth(
            DateTime(year, month),
          );
    state = state.copyWith(
      year: year,
      month: month,
      day: day,
    );
  }

  void updateMonth(int month) {
    final day = (today.year == state.year && today.month == month)
        ? today.day
        : maxDaysInMonth(
            DateTime(state.year, month),
          );
    state = state.copyWith(
      month: month,
      day: day,
    );
  }

  void updateDay(int day) {
    state = state.copyWith(
      day: day,
    );
  }
}