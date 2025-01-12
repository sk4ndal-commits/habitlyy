import '../../viewmodels/habits/habit_viewmodel.dart';

abstract class IHabitsService {
  void addHabit(TimeInvestmentHabitViewModel habit);
  void removeHabit(int habitId);
  List<TimeInvestmentHabitViewModel> getHabits();
  List<TimeInvestmentHabitViewModel> getTodayHabits();
}