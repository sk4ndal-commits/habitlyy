import 'package:habitlyy/habits/viewmodels/habit_viewmodel.dart';

import 'habits_repository.dart';

class HabitsDummyRepository implements IHabitsRepository {
  final List<HabitViewModel> _habits;

  HabitsDummyRepository() : _habits = List.generate(20, (index) {
    return HabitViewModel(
      id: index,
      title: 'Habit $index',
      description: 'Description for habit $index',
      startDate: DateTime.now().subtract(Duration(days: index)),
    );
  });

  @override
  void addHabit(HabitViewModel habit) {
    _habits.add(habit);
  }

  @override
  void removeHabit(int habitId) {
    _habits.removeWhere((habit) => habit.id == habitId);
  }

  @override
  List<HabitViewModel> getHabits() {
    return _habits;
  }
}
