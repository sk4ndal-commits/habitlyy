import '../viewmodels/habit_viewmodel.dart';

abstract class IHabitsRepository {
  void addHabit(HabitViewModel habit);
  void removeHabit(int habitId);
  List<HabitViewModel> getHabits();
}