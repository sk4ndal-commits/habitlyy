import '../../viewmodels/habits/habit_viewmodel.dart';

abstract class IHabitsRepository {
  Future<void> addHabitAsync(TimeInvestmentHabitViewModel habit);
  Future<void> deleteHabitAsync(int habitId);
  Future<void> updateHabitAsync(TimeInvestmentHabitViewModel habit);
  Future<List<TimeInvestmentHabitViewModel>> getHabitsAsync();
  Future<List<TimeInvestmentHabitViewModel>> getHabitsByUserIdAsync(int userId);
}