import 'package:habitlyy/enums/frequency_days.dart';

import '../../enums/habit_priority.dart';
import '../../viewmodels/habits/habit_viewmodel.dart';
import 'habits_repository.dart';

class HabitsDummyRepository implements IHabitsRepository {
  final List<TimeInvestmentHabitViewModel> _habits = [];

  final List<FrequencyDays> _frequencyDays = [
    FrequencyDays.MONDAY,
    FrequencyDays.TUESDAY,
    FrequencyDays.WEDNESDAY,
    FrequencyDays.THURSDAY,
    FrequencyDays.FRIDAY,
    FrequencyDays.SATURDAY,
    FrequencyDays.SUNDAY
  ];

  HabitsDummyRepository() {
    for (int index = 0; index < 20; index++) {
      _habits.add(TimeInvestmentHabitViewModel(
          id: index,
          title: 'Habit $index',
          priority: HabitPriority.HIGH,
          startDate: DateTime.now().subtract(Duration(days: index)),
          deadline: DateTime.now().add(Duration(days: index)),
          targetHours: index * 1.0,
          frequencyDays: (index % 2 == 0
              ? [_frequencyDays[index % 7]]
              : [_frequencyDays[index % 7], _frequencyDays[(index + 1) % 7]])));
    }
  }

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
