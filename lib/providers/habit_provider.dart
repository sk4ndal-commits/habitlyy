import 'package:flutter/cupertino.dart';
import 'package:habitlyy/service_locator.dart';
import 'package:habitlyy/services/habits/ihabits_service.dart';
import 'dart:math';

import '../viewmodels/habits/habit_viewmodel.dart';

class HabitsProvider with ChangeNotifier {
  final IHabitsService _habitsService = getIt<IHabitsService>(); // Reference to habits service
  List<TimeInvestmentHabitViewModel> _todayHabits = [];

  List<TimeInvestmentHabitViewModel> get todayHabits => _todayHabits;

  void setTodayHabitsAsync(List<TimeInvestmentHabitViewModel> habits) {
    _todayHabits = habits;
    notifyListeners();
  }

  /// Update invested hours locally and via the service
  Future<void> updateInvestedHoursAsync(
      TimeInvestmentHabitViewModel habit, double hours) async {
    habit.investedHours = min(habit.targetHours, habit.investedHours + hours);
    notifyListeners(); // Update the UI immediately

    try {
      // Update the service/backend asynchronously
      await _habitsService.updateHabitAsync(habit);
    } catch (e) {
      // Handle error (e.g., revert local update, show UI message)
      print('Error updating invested hours: $e');
    }
  }
}