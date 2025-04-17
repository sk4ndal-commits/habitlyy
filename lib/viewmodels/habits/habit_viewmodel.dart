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
    required this.targetHours,
    required List<FrequencyDay>? frequencyDays,
  }) : super(
          id: id,
          title: title,
          priority: priority,
          frequencyDays: frequencyDays,
        );

  /// Convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'priority': priority.toString(),
      'targetHours': targetHours,
      'investedHours': investedHours,
      'progressLog': _serializeProgressLog(),
      'frequencyDays': frequencyDays?.map((day) => day.index).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Helper method to serialize progress log
  String _serializeProgressLog() {
    if (progressLog.isEmpty) return '';

    return progressLog.map((log) {
      final date = log['date'] is DateTime 
          ? (log['date'] as DateTime).toIso8601String()
          : log['date'].toString();
      return '$date:${log['hours']}';
    }).join('|');
  }

  /// Create an object from JSON
  factory TimeInvestmentHabitViewModel.fromJson(Map<String, dynamic> json) {
    try {
      final habit = TimeInvestmentHabitViewModel(
        id: json['id'] as int,
        title: json['title'] as String,
        priority: HabitPriority.values
            .firstWhere((e) => e.toString() == json['priority']),
        targetHours: (json['targetHours'] as num).toDouble(),
        frequencyDays: _parseFrequencyDays(json['frequencyDays']),
      );

      // Set additional properties if available
      if (json.containsKey('investedHours')) {
        habit.investedHours = (json['investedHours'] as num).toDouble();
      }

      // Parse progress log if available
      if (json.containsKey('progressLog') && json['progressLog'] != null) {
        habit.progressLog = _parseProgressLog(json['progressLog']);
      }

      // Set lastUpdated if available
      if (json.containsKey('lastUpdated') && json['lastUpdated'] != null) {
        try {
          habit.lastUpdated = DateTime.parse(json['lastUpdated'] as String);
        } catch (e) {
          habit.lastUpdated = DateTime.now();
        }
      }

      return habit;
    } catch (e) {
      print('Error parsing JSON to habit: $e');
      throw Exception('Failed to parse JSON to habit: $e');
    }
  }

  /// Helper method to parse frequency days from JSON
  static List<FrequencyDay>? _parseFrequencyDays(dynamic frequencyDays) {
    if (frequencyDays == null) return null;

    try {
      // Handle List format (most common case)
      if (frequencyDays is List<dynamic>) {
        return _parseFrequencyDaysList(frequencyDays);
      } 
      // Handle String format (comma-separated)
      else if (frequencyDays is String) {
        return _parseFrequencyDaysString(frequencyDays);
      }
    } catch (e) {
      print('Error parsing frequency days: $e');
    }

    // Default to Monday if parsing fails
    return [FrequencyDay.MONDAY];
  }

  /// Parse frequency days from a list
  static List<FrequencyDay> _parseFrequencyDaysList(List<dynamic> daysList) {
    return daysList.map((e) {
      if (e is int && e >= 0 && e < FrequencyDay.values.length) {
        return FrequencyDay.values[e];
      } else {
        final String dayStr = e.toString();
        for (final day in FrequencyDay.values) {
          if (day.toString() == dayStr) {
            return day;
          }
        }
        return FrequencyDay.MONDAY; // Default
      }
    }).toList();
  }

  /// Parse frequency days from a comma-separated string
  static List<FrequencyDay> _parseFrequencyDaysString(String daysString) {
    return daysString.split(',').map((day) {
      final trimmed = day.trim();
      final index = int.tryParse(trimmed);

      if (index != null && index >= 0 && index < FrequencyDay.values.length) {
        return FrequencyDay.values[index];
      }

      for (final freqDay in FrequencyDay.values) {
        if (freqDay.toString() == trimmed) {
          return freqDay;
        }
      }

      return FrequencyDay.MONDAY; // Default
    }).toList();
  }

  /// Helper method to parse progress log from JSON
  static List<Map<String, dynamic>> _parseProgressLog(dynamic progressLog) {
    if (progressLog == null) return [];

    try {
      // Handle String format (pipe-separated entries)
      if (progressLog is String) {
        return _parseProgressLogString(progressLog);
      } 
      // Handle List format
      else if (progressLog is List) {
        return _parseProgressLogList(progressLog);
      }
    } catch (e) {
      print('Error parsing progress log: $e');
    }

    return [];
  }

  /// Parse progress log from a pipe-separated string
  static List<Map<String, dynamic>> _parseProgressLogString(String logString) {
    if (logString.isEmpty) return [];

    return logString.split('|').map((logEntry) {
      final parts = logEntry.split(':');
      if (parts.length != 2) return _createDefaultLogEntry();

      try {
        final date = DateTime.parse(parts[0]);
        final hours = double.parse(parts[1]);
        return {'date': date, 'hours': hours};
      } catch (e) {
        return _createDefaultLogEntry();
      }
    }).toList();
  }

  /// Parse progress log from a list
  static List<Map<String, dynamic>> _parseProgressLogList(List<dynamic> logList) {
    return logList.map((log) {
      if (log is Map<String, dynamic>) {
        try {
          final date = log['date'] is String 
              ? DateTime.parse(log['date'] as String)
              : log['date'] as DateTime;
          final hours = (log['hours'] as num).toDouble();
          return {'date': date, 'hours': hours};
        } catch (e) {
          return _createDefaultLogEntry();
        }
      }
      return _createDefaultLogEntry();
    }).toList();
  }

  /// Create a default log entry with current date and zero hours
  static Map<String, dynamic> _createDefaultLogEntry() {
    return {'date': DateTime.now(), 'hours': 0.0};
  }

  /// Create an object from a database map
  factory TimeInvestmentHabitViewModel.fromMap(Map<String, dynamic> map) {
    try {
      final habit = TimeInvestmentHabitViewModel(
        id: map['id'] as int,
        title: map['title'] as String,
        priority: HabitPriority.values.firstWhere(
          (e) => e.toString() == map['priority'],
          orElse: () => HabitPriority.LOW,
        ),
        targetHours: (map['targetHours'] as num).toDouble(),
        frequencyDays: map['frequencyDays'] != null
            ? _parseFrequencyDays(map['frequencyDays'])
            : null,
      );

      // Set investedHours if available
      if (map.containsKey('investedHours') && map['investedHours'] != null) {
        habit.investedHours = (map['investedHours'] as num).toDouble();
      }

      // Parse progress log if available
      if (map.containsKey('progressLog') && map['progressLog'] != null) {
        habit.progressLog = _parseProgressLog(map['progressLog']);
      }

      // Set lastUpdated if available
      if (map.containsKey('lastUpdated') && map['lastUpdated'] != null) {
        try {
          habit.lastUpdated = DateTime.parse(map['lastUpdated'] as String);
        } catch (e) {
          habit.lastUpdated = DateTime.now();
        }
      }

      return habit;
    } catch (e) {
      print('Error mapping database row to habit: $e');
      throw Exception('Failed to map database row to habit: $e');
    }
  }

  /// Log time spent on the habit
  void logTime(DateTime date, double hours) {
    // Log time and update total invested hours
    progressLog.add({'date': date, 'hours': hours});
    investedHours += hours;
    lastUpdated = DateTime.now();
  }

  /// Check if the habit is completed (invested hours >= target hours)
  @override
  bool isCompleted() {
    return investedHours >= targetHours;
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

  /// Calculate the percentage of target hours completed
  @override
  double calculateCompletionPercentage() {
    return (investedHours / targetHours * 100).clamp(0, 100);
  }
}

extension DateTimeExtension on DateTime {
  int weekOfYear() {
    // More efficient ISO 8601 week number calculation
    // January 4th is always in week 1 according to ISO 8601
    final jan4 = DateTime(year, 1, 4);
    final jan4Weekday = jan4.weekday;

    // Find the first Monday of week 1
    final firstMonday = jan4.subtract(Duration(days: jan4Weekday - 1));

    // Calculate days since the first Monday of the year
    final daysSinceFirstMonday = difference(firstMonday).inDays;

    // Calculate the week number
    if (daysSinceFirstMonday < 0) {
      // Date is before the first week of this year, get week of previous year
      final dec31LastYear = DateTime(year - 1, 12, 31);
      return dec31LastYear.weekOfYear();
    }

    return (daysSinceFirstMonday / 7).floor() + 1;
  }
}
