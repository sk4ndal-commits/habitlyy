import '../../viewmodels/habits/habit_viewmodel.dart';

abstract class IHabitsRepository {
  Future<void> addHabit(TimeInvestmentHabitViewModel habit);
  Future<void> deleteHabit(int habitId);
  Future<List<TimeInvestmentHabitViewModel>> getHabits();
  Future<List<TimeInvestmentHabitViewModel>> getHabitsByUserId(int userId);
}