import 'package:habitlyy/service_locator.dart';

import '../repositories/habits_repository.dart';
import '../viewmodels/habit_viewmodel.dart';

abstract class IHabitsService {
  void addHabit(HabitViewModel habit);
  void removeHabit(int habitId);
  List<HabitViewModel> getHabits();
}


class HabitsService implements IHabitsService {
  final _repository = getIt<IHabitsRepository>();

  HabitsService();

  @override
  void addHabit(HabitViewModel habit) {
    _repository.addHabit(habit);
  }

  @override
  void removeHabit(int habitId) {
    _repository.removeHabit(habitId);
  }

  @override
  List<HabitViewModel> getHabits() {
    return _repository.getHabits();
  }
}