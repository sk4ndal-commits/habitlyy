import 'dart:core';

import '../../enums/frequency_days.dart';
import '../../enums/habit_priority.dart';
import 'habit_viewmodel_base.dart';

class TimeInvestmentHabitViewModel extends HabitViewModelBase {
  double targetHours;
  double investedHours = 0;
  List<Map<String, dynamic>> progressLog = []; // Holds progress logs

  TimeInvestmentHabitViewModel({
    required int id,
    required String title,
    required HabitPriority priority,
    required DateTime startDate,
    required DateTime deadline,
    required this.targetHours,
    required List<FrequencyDays>? frequencyDays,
  }) : super(
          id: id,
          title: title,
          priority: priority,
          startDate: startDate,
          deadline: deadline,
          frequencyDays: frequencyDays,
        );

  void logTime(DateTime date, double hours) {
    // Log time and update total invested hours
    progressLog.add({'date': date, 'hours': hours});
    investedHours += hours;
    lastUpdated = DateTime.now();
  }

  double hoursCompleted() {
    return investedHours;
  }

  bool isCompleted() {
    return investedHours >= targetHours;
  }

  bool isOverdue() {
    return DateTime.now().isAfter(deadline);
  }

  List<Map<String, dynamic>> getCumulativeProgress() {
    // Calculate cumulative progress grouped by date
    double cumulativeHours = 0;
    List<Map<String, dynamic>> progressOverTime = [];

    // Sort progress logs according to date
    progressLog.sort(
        (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));

    for (var log in progressLog) {
      cumulativeHours += log['hours'];
      progressOverTime.add({
        'date': log['date'],
        'cumulative_hours': cumulativeHours,
      });
    }

    return progressOverTime;
  }

  Map<DateTime, double> getDailyProgress() {
    // Calculate daily progress
    Map<DateTime, double> dailyProgress = {};

    for (var log in progressLog) {
      DateTime dateKey = log['date'].toLocal();
      if (dailyProgress.containsKey(dateKey)) {
        dailyProgress[dateKey] = dailyProgress[dateKey]! + log['hours'];
      } else {
        dailyProgress[dateKey] = log['hours'];
      }
    }

    return dailyProgress;
  }

  Map<String, double> getWeeklyProgress() {
    // Aggregate hours spent weekly
    Map<String, double> weeklyProgress = {};

    for (var log in progressLog) {
      DateTime date = log['date'];
      String weekKey = '${date.year}-W${date.weekOfYear()}';

      if (weeklyProgress.containsKey(weekKey)) {
        weeklyProgress[weekKey] = weeklyProgress[weekKey]! + log['hours'];
      } else {
        weeklyProgress[weekKey] = log['hours'];
      }
    }

    return weeklyProgress;
  }

  double calculateCompletionPercentage() {
    // Calculate the percentage of target hours completed
    return (investedHours / targetHours * 100).clamp(0, 100);
  }
}

extension DateTimeExtension on DateTime {
  int weekOfYear() {
    // ISO 8601 week number calculation
    final beginningOfYear = DateTime(year, 1, 1);
    final firstThursday =
        beginningOfYear.add(Duration(days: (4 - beginningOfYear.weekday) % 7));
    final startOfWeekOne =
        firstThursday.subtract(Duration(days: firstThursday.weekday - 1));

    // Calculate the difference between the date and the start of Week 1
    final difference = this.difference(startOfWeekOne).inDays;

    // Calculate the week number
    int weekNumber = (difference / 7).ceil() + 1;
    return weekNumber > 0 ? weekNumber : 1;
  }
}
