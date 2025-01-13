import 'dart:math';

import 'package:flutter/material.dart';
import 'package:habitlyy/viewmodels/habits/habit_viewmodel.dart';

class HabitsProvider with ChangeNotifier {
  List<TimeInvestmentHabitViewModel> _todayHabits = [];

  List<TimeInvestmentHabitViewModel> get todayHabits => _todayHabits;

  void setTodayHabits(List<TimeInvestmentHabitViewModel> habits) {
    _todayHabits = habits;
    notifyListeners();
  }

  void updateInvestedHours(TimeInvestmentHabitViewModel habit, double hours) {

    habit.investedHours = min(habit.targetHours, habit.investedHours + hours);
    notifyListeners();
  }
}