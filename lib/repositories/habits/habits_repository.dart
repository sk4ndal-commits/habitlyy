import '../../viewmodels/habits/habit_viewmodel.dart';

abstract class IHabitsRepository {
  void addHabit(TimeInvestmentHabitViewModel habit);
  void removeHabit(int habitId);
  List<TimeInvestmentHabitViewModel> getHabits();
  List<TimeInvestmentHabitViewModel> getHabitsByUserId(int userId);
}