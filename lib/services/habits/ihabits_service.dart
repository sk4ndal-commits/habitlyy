import '../../viewmodels/habits/habit_viewmodel.dart';

abstract class IHabitsService {
  Future<void> addHabit(TimeInvestmentHabitViewModel habit);
  Future<void> removeHabit(int habitId);
  Future<List<TimeInvestmentHabitViewModel>> getHabits();
  Future<List<TimeInvestmentHabitViewModel>> getTodayHabits();
  Future<List<TimeInvestmentHabitViewModel>> getHabitsByUserId(int userId);
}