import 'package:habitlyy/habits/viewmodels/habit_viewmodel.dart';

import '../enums/goal_priority.dart';
import 'habits_repository.dart';

class HabitsDummyRepository implements IHabitsRepository {
  final List<TimeInvestmentHabitViewModel> _habits;

  HabitsDummyRepository() : _habits = List.generate(20, (index) {
    return TimeInvestmentHabitViewModel(
      id: index,
      title: 'Habit $index',
      priority: GoalPriority.HIGH,
      startDate: DateTime.now().subtract(Duration(days: index)),
      deadline: DateTime.now().add(Duration(days: index)),
      targetHours: index * 1.0
    );
  });

  @override
  void addHabit(TimeInvestmentHabitViewModel habit) {
    _habits.add(habit);
  }

  @override
  void removeHabit(int habitId) {
    _habits.removeWhere((habit) => habit.id == habitId);
  }

  @override
  List<TimeInvestmentHabitViewModel> getHabits() {
    return _habits;
  }
}
