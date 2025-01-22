import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/habits/ihabits_service.dart';
import '../viewmodels/habits/habit_viewmodel.dart';

/// Adds an in-memory provider layer on top of the <cref="IHabitsService">
/// for efficient state management
class HabitsProvider with ChangeNotifier {
  final IHabitsService _habitsService; // Service is injected into the provider

  // In-memory state for today's habits
  List<TimeInvestmentHabitViewModel> _todayHabits = [];

  List<TimeInvestmentHabitViewModel> get todayHabits => _todayHabits;

  // Constructor for dependency injection
  HabitsProvider(this._habitsService);

  /// Load habits for the logged-in user from the backend
  Future<void> loadHabitsAsync(int userId) async {
    _todayHabits = await _habitsService.getHabitsByUserIdAsync(userId);
    notifyListeners(); // Notify listeners that habits are loaded
  }

  /// Retrieve filtered and sorted habits (with invested hours < target hours)
  List<TimeInvestmentHabitViewModel> get filteredAndSortedHabits {
    final filteredHabits = _todayHabits
        .where((habit) => habit.investedHours < habit.targetHours)
        .toList();

    filteredHabits.sort((a, b) => b.priority.index.compareTo(a.priority.index));

    return filteredHabits;
  }


  /// Add a new habit
  Future<void> addHabitAsync(TimeInvestmentHabitViewModel habit) async {
    await _habitsService.addHabitAsync(habit); // Save habit via service
    _todayHabits.add(habit); // Add habit to the in-memory list
    notifyListeners(); // Notify listeners about the addition
  }

  void _sortHabits() {
    _todayHabits.sort((a, b) => a.priority.index.compareTo(b.priority.index));
  }

  /// Update an existing habit
  Future<void> updateHabitAsync(TimeInvestmentHabitViewModel updatedHabit) async {
    await _habitsService
        .updateHabitAsync(updatedHabit); // Update habit via service
    final index = _todayHabits.indexWhere((h) => h.id == updatedHabit.id);
    if (index != -1) {
      _todayHabits[index] = updatedHabit; // Update in-memory habit
      _sortHabits();
      notifyListeners(); // Notify listeners about the update
    }
  }

  /// Delete a habit by its ID
  Future<void> deleteHabitAsync(int habitId) async {
    await _habitsService.deleteHabitAsync(habitId); // Remove habit via service
    _todayHabits.removeWhere((habit) => habit.id == habitId); // Update state

    await _saveHabitsToLocalStorage();

    notifyListeners(); // Notify listeners about the deletion
  }

  /// Initialize habits and handle resetting invested hours for a new day
  Future<void> initializeHabitsAsync(int userId) async {
    // Reset invested hours if it's a new day
    await _resetInvestedHoursIfNewDay();

    // Fetch today's habits from the backend for the logged-in user
    _todayHabits = await _habitsService.getHabitsByUserIdAsync(userId);

    // Sync `investedHours` values from local storage
    await _syncInvestedHoursFromLocalStorage();

    notifyListeners(); // Notify widgets of the updated state
  }

  /// Update `investedHours` locally and persist the changes
  Future<void> updateInvestedHoursAsync(
      TimeInvestmentHabitViewModel habit, double hours) async {
    // Limit `investedHours` to the habit's target
    habit.investedHours = min(habit.targetHours, habit.investedHours + hours);

    // Notify listeners immediately to update the UI
    notifyListeners();

    // Persist the updated state to local storage
    await _saveHabitsToLocalStorage();
  }

  /// Save today's habits to local storage
  Future<void> _saveHabitsToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();

    // Serialize habits into a JSON string
    final habitListJson = jsonEncode(
      _todayHabits.map((habit) => habit.toJson()).toList(),
    );

    // Persist the JSON string to local storage
    await prefs.setString('todayHabits', habitListJson);
  }

  /// Synchronize saved `investedHours` from local storage to in-memory habits
  Future<void> _syncInvestedHoursFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the JSON string of saved habits
    final habitListJson = prefs.getString('todayHabits');
    if (habitListJson == null) return; // No data to sync

    // Parse the saved habits JSON as a list
    final List<dynamic> savedHabitsJson = jsonDecode(habitListJson);

    // Update `investedHours` for matching habits in `_todayHabits`
    for (final savedHabitJson in savedHabitsJson) {
      final habitFromStorage =
          TimeInvestmentHabitViewModel.fromJson(savedHabitJson);

      try {
        // Find the corresponding habit by ID in `_todayHabits`
        final matchingHabit =
            _todayHabits.firstWhere((h) => h.id == habitFromStorage.id);

        // Sync the `investedHours` value from storage
        if (matchingHabit != null) {
          matchingHabit.investedHours = habitFromStorage.investedHours;
        }
      } catch (e) {
        // Ignore if no matching habit is found
      }
    }
  }

  /// Reset `investedHours` to zero for all habits if it's a new day
  Future<void> _resetInvestedHoursIfNewDay() async {
    final prefs = await SharedPreferences.getInstance();

    // Get the last recorded reset date
    final lastResetDate = prefs.getString('lastResetDate') ?? '';
    final currentDate = _getCurrentDateString();

    if (lastResetDate != currentDate) {
      // Reset `investedHours` for all habits
      for (final habit in _todayHabits) {
        habit.investedHours = 0;
      }

      // Save the reset habits and update the last reset date
      await _saveHabitsToLocalStorage();
      await prefs.setString('lastResetDate', currentDate);

      // Notify listeners about the reset
      notifyListeners();
    }
  }

  /// Get the current date in "YYYY-MM-DD" format
  String _getCurrentDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
