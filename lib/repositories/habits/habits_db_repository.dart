import 'package:sqflite/sqflite.dart';
import '../../enums/frequency_days.dart';
import '../../enums/habit_priority.dart';
import '../../viewmodels/habits/habit_viewmodel.dart';
import 'habits_repository.dart';

/// Repository implementation that uses SQLite database for habit storage
///
/// This repository handles all database operations for habits including
/// creating, reading, updating, and deleting habits. It implements the
/// [IHabitsRepository] interface to provide a consistent API for habit data access.
class HabitsDBRepository implements IHabitsRepository {
  late final Database _database;

  /// Constructor to initialize the database
  ///
  /// Requires an initialized [Database] instance to be passed in.
  HabitsDBRepository(this._database);

  /// Adds a new habit to the database
  ///
  /// Takes a [TimeInvestmentHabitViewModel] and persists it to the database.
  /// All properties of the habit are stored, including invested hours and progress log.
  /// Throws an exception if the operation fails.
  @override
  Future<void> addHabitAsync(TimeInvestmentHabitViewModel habit) async {
    try {
      await _database.insert(
        'habits',
        {
          'title': habit.title,
          'priority': habit.priority.toString(),
          'targetHours': habit.targetHours,
          'investedHours': habit.investedHours,
          'progressLog': _serializeProgressLog(habit.progressLog),
          'frequencyDays': habit.frequencyDays != null
              ? habit.frequencyDays?.map((e) => e.index).join(",")
              : null,
          'lastUpdated': habit.lastUpdated.toIso8601String(),
        },
      );
    } catch (e) {
      print('Error adding habit: $e');
      throw Exception('Failed to add habit: $e');
    }
  }

  // Helper method to serialize progress log
  String _serializeProgressLog(List<Map<String, dynamic>> progressLog) {
    if (progressLog.isEmpty) return '';

    return progressLog.map((log) {
      final date = log['date'] is DateTime 
          ? (log['date'] as DateTime).toIso8601String()
          : log['date'].toString();
      return '$date:${log['hours']}';
    }).join('|');
  }

  /// Updates an existing habit in the database
  ///
  /// Takes a [TimeInvestmentHabitViewModel] and updates its record in the database.
  /// All properties of the habit are updated, including invested hours and progress log.
  /// Throws an exception if the operation fails or if the habit doesn't exist.
  @override
  Future<void> updateHabitAsync(TimeInvestmentHabitViewModel habit) async {
    try {
      await _database.update(
        'habits',
        {
          'title': habit.title,
          'priority': habit.priority.toString(),
          'targetHours': habit.targetHours,
          'investedHours': habit.investedHours,
          'progressLog': _serializeProgressLog(habit.progressLog),
          'frequencyDays': habit.frequencyDays != null
              ? habit.frequencyDays?.map((e) => e.index).join(",")
              : null,
          'lastUpdated': habit.lastUpdated.toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [habit.id],
      );
    } catch (e) {
      print('Error updating habit: $e');
      throw Exception('Failed to update habit: $e');
    }
  }

  /// Deletes a habit from the database by its ID
  ///
  /// Takes a habit ID and removes the corresponding record from the database.
  /// Throws an exception if the operation fails.
  @override
  Future<void> deleteHabitAsync(int habitId) async {
    try {
      await _database.delete(
        'habits',
        where: 'id = ?',
        whereArgs: [habitId],
      );
    } catch (e) {
      print('Error deleting habit: $e');
      throw Exception('Failed to delete habit: $e');
    }
  }

  /// Retrieves all habits from the database
  ///
  /// Returns a list of [TimeInvestmentHabitViewModel] objects representing all habits in the database.
  /// Each habit is fully populated with all properties including invested hours and progress log.
  /// Throws an exception if the operation fails.
  @override
  Future<List<TimeInvestmentHabitViewModel>> getHabitsAsync() async {
    try {
      final rows = await _database.query('habits');
      return rows.map((row) => _mapRowToHabit(row)).toList();
    } catch (e) {
      print('Error getting habits: $e');
      throw Exception('Failed to get habits: $e');
    }
  }

  /// Retrieves habits for a specific user by their user ID
  ///
  /// Takes a user ID and returns a list of [TimeInvestmentHabitViewModel] objects
  /// representing all habits associated with that user.
  /// Each habit is fully populated with all properties including invested hours and progress log.
  /// Throws an exception if the operation fails.
  @override
  Future<List<TimeInvestmentHabitViewModel>> getHabitsByUserIdAsync(
      int userId) async {
    try {
      final rows = await _database.query(
        'habits',
        where: 'userId = ?',
        whereArgs: [userId],
      );
      return rows.map((row) => _mapRowToHabit(row)).toList();
    } catch (e) {
      print('Error getting habits by user ID: $e');
      throw Exception('Failed to get habits by user ID: $e');
    }
  }

  /// Helper function to convert a database row to a TimeInvestmentHabitViewModel
  ///
  /// Takes a database row as a Map and converts it to a [TimeInvestmentHabitViewModel].
  /// Handles all properties including invested hours, progress log, and lastUpdated.
  /// Throws an exception if the mapping fails.
  TimeInvestmentHabitViewModel _mapRowToHabit(Map<String, dynamic> row) {
    try {
      final habit = TimeInvestmentHabitViewModel(
        id: row['id'] as int,
        title: row['title'] as String,
        priority: _parsePriority(row['priority'] as String),
        targetHours: row['targetHours'] as double,
        frequencyDays: row['frequencyDays'] != null
            ? _parseFrequencyDays(row['frequencyDays'] as String)
            : null,
      );

      // Set additional properties
      habit.investedHours = row['investedHours'] != null 
          ? (row['investedHours'] as num).toDouble() 
          : 0.0;

      // Parse progress log if available
      if (row['progressLog'] != null && (row['progressLog'] as String).isNotEmpty) {
        habit.progressLog = _parseProgressLog(row['progressLog'] as String);
      }

      // Set lastUpdated if available
      if (row['lastUpdated'] != null) {
        try {
          habit.lastUpdated = DateTime.parse(row['lastUpdated'] as String);
        } catch (e) {
          habit.lastUpdated = DateTime.now();
        }
      }

      return habit;
    } catch (e) {
      print('Error mapping row to habit: $e');
      throw Exception('Failed to map database row to habit: $e');
    }
  }

  /// Helper method to parse progress log from string
  ///
  /// Takes a string representation of progress log and converts it to a list of maps.
  /// Each map contains 'date' and 'hours' keys.
  /// Returns an empty list if the input is empty or invalid.
  List<Map<String, dynamic>> _parseProgressLog(String progressLogStr) {
    if (progressLogStr.isEmpty) return [];

    return progressLogStr.split('|').map((logEntry) {
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
  }

  /// Parse habit priority from string to enum
  ///
  /// Takes a string representation of a priority and converts it to a [HabitPriority] enum.
  /// Returns [HabitPriority.LOW] as a fallback if the string doesn't match any enum value.
  HabitPriority _parsePriority(String value) {
    return HabitPriority.values.firstWhere(
      (priority) => priority.toString() == value,
      orElse: () => HabitPriority.LOW, // Fallback
    );
  }

  /// Parse frequency days string to a list of enum values
  ///
  /// Takes a string representation of frequency days and converts it to a list of [FrequencyDay] enums.
  /// Supports both index-based format (e.g., "0,1,2") and string-based format (e.g., "MONDAY,TUESDAY").
  /// Returns a list with [FrequencyDay.MONDAY] as a fallback if parsing fails.
  List<FrequencyDay> _parseFrequencyDays(String value) {
    try {
      return value
          .split(',')
          .map((day) {
            try {
              // Try to parse as index first (new format)
              final index = int.tryParse(day.trim());
              if (index != null && index >= 0 && index < FrequencyDay.values.length) {
                return FrequencyDay.values[index];
              }

              // Fallback to string parsing (old format)
              return FrequencyDay.values.firstWhere(
                (freqDay) => freqDay.toString() == day.trim(),
                orElse: () => FrequencyDay.MONDAY,
              );
            } catch (e) {
              return FrequencyDay.MONDAY;
            }
          })
          .toList();
    } catch (e) {
      print('Error parsing frequency days: $e');
      return [FrequencyDay.MONDAY];
    }
  }
}
