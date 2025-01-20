import '../../viewmodels/habits/habit_viewmodel.dart';

abstract class IHabitsService {
  Future<void> addHabitAsync(TimeInvestmentHabitViewModel habit);
  Future<void> deleteHabitAsync(int habitId);
  Future<void> updateHabitAsync(TimeInvestmentHabitViewModel habit);
  Future<List<TimeInvestmentHabitViewModel>> getHabitsAsync();
  Future<List<TimeInvestmentHabitViewModel>> getTodayHabitsAsync();
  Future<List<TimeInvestmentHabitViewModel>> getHabitsByUserIdAsync(int userId);
}