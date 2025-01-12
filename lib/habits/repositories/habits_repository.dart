import '../viewmodels/habit_viewmodel.dart';

abstract class IHabitsRepository {
  void addHabit(TimeInvestmentHabitViewModel habit);
  void removeHabit(int habitId);
  List<TimeInvestmentHabitViewModel> getHabits();
}