import 'package:habitlyy/service_locator.dart';

import '../../repositories/habits/habits_repository.dart';
import '../../viewmodels/habits/habit_viewmodel.dart';

abstract class IHabitsService {
  void addHabit(TimeInvestmentHabitViewModel habit);
  void removeHabit(int habitId);
  List<TimeInvestmentHabitViewModel> getHabits();
}


class HabitsService implements IHabitsService {
  final _repository = getIt<IHabitsRepository>();

  HabitsService();

  @override
  void addHabit(TimeInvestmentHabitViewModel habit) {
    _repository.addHabit(habit);
  }

  @override
  void removeHabit(int habitId) {
    _repository.removeHabit(habitId);
  }

  @override
  List<TimeInvestmentHabitViewModel> getHabits() {
    return _repository.getHabits();
  }
}