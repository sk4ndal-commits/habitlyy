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
      if (frequencyDays is List<dynamic>) {
        return frequencyDays.map((e) {
          if (e is int) {
            // Handle index-based format
            return FrequencyDay.values[e];
          } else {
            // Handle string-based format
            return FrequencyDay.values.firstWhere(
              (f) => f.toString() == e.toString(),
              orElse: () => FrequencyDay.MONDAY,
            );
          }
        }).toList();
      } else if (frequencyDays is String) {
        // Handle comma-separated string format
        return frequencyDays.split(',').map((day) {
          final index = int.tryParse(day.trim());
          if (index != null && index >= 0 && index < FrequencyDay.values.length) {
            return FrequencyDay.values[index];
          }
          return FrequencyDay.values.firstWhere(
            (f) => f.toString() == day.trim(),
            orElse: () => FrequencyDay.MONDAY,
          );
        }).toList();
      }
    } catch (e) {
      print('Error parsing frequency days: $e');
    }

    return [FrequencyDay.MONDAY];
  }

  /// Helper method to parse progress log from JSON
  static List<Map<String, dynamic>> _parseProgressLog(dynamic progressLog) {
    if (progressLog == null) return [];

    try {
      if (progressLog is String) {
        if (progressLog.isEmpty) return [];

        return progressLog.split('|').map((logEntry) {
          final parts = logEntry.split(':');
          if (parts.length != 2) return {'date': DateTime.now(), 'hours': 0.0};

          DateTime date;
          try {
            date = DateTime.parse(parts[0]);
          } catch (e) {
            date = DateTime.now();
          }

          double hours;
          try {
            hours = double.parse(parts[1]);
          } catch (e) {
            hours = 0.0;
          }

          return {'date': date, 'hours': hours};
        }).toList();
      } else if (progressLog is List) {
        return progressLog.map((log) {
          if (log is Map<String, dynamic>) {
            final date = log['date'] is String 
                ? DateTime.parse(log['date'] as String)
                : log['date'] as DateTime;
            final hours = (log['hours'] as num).toDouble();
            return {'date': date, 'hours': hours};
          }
          return {'date': DateTime.now(), 'hours': 0.0};
        }).toList();
      }
    } catch (e) {
      print('Error parsing progress log: $e');
    }

    return [];
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
