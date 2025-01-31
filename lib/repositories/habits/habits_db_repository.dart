import 'package:sqflite/sqflite.dart';
import '../../enums/frequency_days.dart';
import '../../enums/habit_priority.dart';
import '../../viewmodels/habits/habit_viewmodel.dart';
import 'habits_repository.dart';

class HabitsDBRepository implements IHabitsRepository {
  late final Database _database;

  // Constructor to initialize the database
  HabitsDBRepository(this._database);

  // Add a new habit to the database
  @override
  Future<void> addHabitAsync(TimeInvestmentHabitViewModel habit) async {
    await _database.insert(
      'habits',
      {
        'title': habit.title,
        'priority': habit.priority.toString(),
        'targetHours': habit.targetHours,
        'frequencyDays':
            habit.frequencyDays != null ? habit.frequencyDays.toString() : null,
        'userId': habit.userId,
      },
    );
  }

  @override
  Future<void> updateHabitAsync(TimeInvestmentHabitViewModel habit) async {
    await _database.update(
      'habits',
      {
        'title': habit.title,
        'priority': habit.priority.toString(),
        'targetHours': habit.targetHours,
        'frequencyDays': habit.frequencyDays != null
            ? habit.frequencyDays?.map((e) => e.toString()).join(",")
            : null,
        'userId': habit.userId,
      },
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  // Delete a habit by its ID
  @override
  Future<void> deleteHabitAsync(int habitId) async {
    await _database.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [habitId],
    );
  }

  // Get all habits from the database
  @override
  Future<List<TimeInvestmentHabitViewModel>> getHabitsAsync() async {
    final rows = await _database.query('habits');
    return rows.map((row) => _mapRowToHabit(row)).toList();
  }

  // Get habits for a specific user by their user ID
  @override
  Future<List<TimeInvestmentHabitViewModel>> getHabitsByUserIdAsync(
      int userId) async {
    final rows = await _database.query(
      'habits',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return rows.map((row) => _mapRowToHabit(row)).toList();
  }

  // Helper function to convert a database row to a TimeInvestmentHabitViewModel
  TimeInvestmentHabitViewModel _mapRowToHabit(Map<String, dynamic> row) {
    return TimeInvestmentHabitViewModel(
      id: row['id'] as int,
      title: row['title'] as String,
      priority: _parsePriority(row['priority'] as String),
      targetHours: row['targetHours'] as double,
      frequencyDays: row['frequencyDays'] != null
          ? _parseFrequencyDays(row['frequencyDays'] as String)
          : null,
      userId: row['userId'] as int,
    );
  }

  // Parse habit priority from string to enum
  HabitPriority _parsePriority(String value) {
    return HabitPriority.values.firstWhere(
      (priority) => priority.toString() == value,
      orElse: () => HabitPriority.LOW, // Fallback
    );
  }

  // Parse frequency days string to a list of enum values
  List<FrequencyDay> _parseFrequencyDays(String value) {
    return value
        .split(',')
        .map((day) => FrequencyDay.values.firstWhere(
              (freqDay) => freqDay.toString() == day.trim(),
              orElse: () => FrequencyDay.MONDAY,
            ))
        .toList();
  }
}
