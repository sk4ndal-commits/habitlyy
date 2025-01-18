import 'package:habitlyy/enums/frequency_days.dart';

import '../../enums/habit_priority.dart';
import '../../viewmodels/habits/habit_viewmodel.dart';
import 'habits_repository.dart';

class HabitsDummyRepository implements IHabitsRepository {
  final List<TimeInvestmentHabitViewModel> _habits = [];

  final List<FrequencyDay> _frequencyDays = [
    FrequencyDay.MONDAY,
    FrequencyDay.TUESDAY,
    FrequencyDay.WEDNESDAY,
    FrequencyDay.THURSDAY,
    FrequencyDay.FRIDAY,
    FrequencyDay.SATURDAY,
    FrequencyDay.SUNDAY
  ];

  HabitsDummyRepository() {
    for (int index = 0; index < 20; index++) {
      _habits.add(
        TimeInvestmentHabitViewModel(
            id: index,
            title: 'Habit $index',
            priority: HabitPriority.HIGH,
            startDate: DateTime.now().subtract(Duration(days: index)),
            deadline: DateTime.now().add(Duration(days: index)),
            targetHours: index * 1.0 + 0.5,
            frequencyDays: (index % 2 == 0
                ? [_frequencyDays[index % 7]]
                : [_frequencyDays[index % 7], _frequencyDays[(index + 1) % 7]]),
            userId: index),
      );
    }
  }

  @override
  void addHabit(TimeInvestmentHabitViewModel habit) {
    _habits.add(habit);
  }

  @override
  void deleteHabit(int habitId) {
    _habits.removeWhere((habit) => habit.id == habitId);
  }

  @override
  List<TimeInvestmentHabitViewModel> getHabits() {
    return _habits;
  }

  @override
  List<TimeInvestmentHabitViewModel> getHabitsByUserId(int userId) {
    return _habits.where((habit) => habit.userId == userId).toList();
  }
}
