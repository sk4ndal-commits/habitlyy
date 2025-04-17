import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enums/frequency_days.dart';
import '../services/habits/ihabits_service.dart';
import '../viewmodels/habits/habit_viewmodel.dart';

/// Adds an in-memory provider layer on top of the <cref="IHabitsService">
/// for efficient state management
class HabitsProvider with ChangeNotifier {
  final IHabitsService _habitsService; // Service is injected into the provider
  SharedPreferences? _prefs; // Cached SharedPreferences instance

  // In-memory state for today's habits
  List<TimeInvestmentHabitViewModel> _todayHabits = [];

  List<TimeInvestmentHabitViewModel> get todayHabits => _todayHabits;

  // Constructor for dependency injection
  HabitsProvider(this._habitsService);

  /// Retrieve filtered and sorted habits (with invested hours < target hours)
  List<TimeInvestmentHabitViewModel> get filteredAndSortedHabits {
    return _todayHabits
        .where((habit) => habit.investedHours < habit.targetHours)
        .toList()
      ..sort(_priorityComparator);
  }

  /// Add a new habit
  Future<void> addHabitAsync(TimeInvestmentHabitViewModel habit) async {
    // Save habit via service
    await _habitsService.addHabitAsync(habit);

    // Update today's habits dynamically
    await _refreshTodayHabits();

    notifyListeners(); // Notify listeners about the addition
  }

  /// Comparator function for sorting habits by priority (HIGH to LOW)
  int _priorityComparator(TimeInvestmentHabitViewModel a, TimeInvestmentHabitViewModel b) {
    return b.priority.index.compareTo(a.priority.index);
  }

  /// Sort habits by priority
  void _sortHabits() {
    _todayHabits.sort(_priorityComparator);
  }

  /// Update an existing habit
  Future<void> updateHabitAsync(TimeInvestmentHabitViewModel updatedHabit) async {
    // Update the habit in the service
    await _habitsService.updateHabitAsync(updatedHabit);

    // Re-fetch all habits due today
    await _refreshTodayHabits();

    notifyListeners(); // Notify listeners about the changes
  }

  /// Initialize habits and handle resetting invested hours for a new day
  Future<void> initializeHabitsAsync() async {
    // Reset invested hours if it's a new day
    await _resetInvestedHoursIfNewDay();

    // Fetch today's habits and update state
    await _refreshTodayHabits();

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

  /// Get the SharedPreferences instance (cached for performance)
  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Save today's habits to local storage
  Future<void> _saveHabitsToLocalStorage() async {
    final prefs = await _getPrefs();

    // Serialize habits into a JSON string
    final habitListJson = jsonEncode(
      _todayHabits.map((habit) => habit.toJson()).toList(),
    );

    // Persist the JSON string to local storage
    await prefs.setString('todayHabits', habitListJson);
  }

  /// Synchronize saved `investedHours` from local storage to in-memory habits
  Future<void> _syncInvestedHoursFromLocalStorage() async {
    final prefs = await _getPrefs();

    // Retrieve the JSON string of saved habits
    final habitListJson = prefs.getString('todayHabits');
    if (habitListJson == null) return; // No data to sync

    try {
      // Parse the saved habits JSON as a list
      final List<dynamic> savedHabitsJson = jsonDecode(habitListJson);

      // Create a map for faster lookups by ID
      final Map<int, TimeInvestmentHabitViewModel> habitMap = {
        for (var habit in _todayHabits) habit.id: habit
      };

      // Update `investedHours` for matching habits
      for (final savedHabitJson in savedHabitsJson) {
        final habitFromStorage =
        TimeInvestmentHabitViewModel.fromJson(savedHabitJson);

        final matchingHabit = habitMap[habitFromStorage.id];
        if (matchingHabit != null) {
          matchingHabit.investedHours = habitFromStorage.investedHours;
        }
      }
    } catch (e) {
      // Handle JSON parsing errors gracefully
      print('Error syncing habits from local storage: $e');
    }
  }

  /// Reset `investedHours` to zero for all habits if it's a new day
  Future<void> _resetInvestedHoursIfNewDay() async {
    final prefs = await _getPrefs();

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

  // Cache for today's date and day
  DateTime? _today;
  FrequencyDay? _todayDay;

  /// Helper function to check if a habit is due today
  bool _isHabitDueToday(TimeInvestmentHabitViewModel habit) {
    // Get today's date and cache it for the day
    final now = DateTime.now();

    // Only recalculate if the date has changed
    if (_today == null ||
        _today!.year != now.year ||
        _today!.month != now.month ||
        _today!.day != now.day) {
      _today = now;
      _todayDay = FrequencyDay.values[now.weekday - 1];
    }

    // Check if the habit's frequency includes today
    return habit.frequencyDays?.contains(_todayDay) ?? false;
  }

  /// Refresh habits list to only include those due today
  Future<void> _refreshTodayHabits() async {
    // Fetch all habits from the service
    final allHabits = await _habitsService.getHabitsAsync();

    // Filter habits due today
    _todayHabits = allHabits.where(_isHabitDueToday).toList();

    // Sync invested hours from local storage
    await _syncInvestedHoursFromLocalStorage();

    // Sort habits by priority
    _sortHabits();
  }

  /// Delete a habit by its ID
  Future<void> deleteHabitAsync(int habitId) async {
    await _habitsService.deleteHabitAsync(habitId); // Remove habit via service

    // Update today's habits
    await _refreshTodayHabits();

    notifyListeners(); // Notify listeners about the deletion
  }
}