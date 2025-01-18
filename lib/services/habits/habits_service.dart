import 'package:habitlyy/enums/frequency_days.dart';

import '../../repositories/habits/habits_repository.dart';
import '../../service_locator.dart';
import '../../viewmodels/habits/habit_viewmodel.dart';
import '../profile/iuser_service.dart';
import 'ihabits_service.dart';

class HabitsService implements IHabitsService {
  final _repository = getIt<IHabitsRepository>();
  final userService = getIt<IUserService>();

  HabitsService();

  void addHabit(TimeInvestmentHabitViewModel habit) {
    _repository.addHabit(habit);
  }

  void removeHabit(int habitId) {
    _repository.removeHabit(habitId);
  }

  List<TimeInvestmentHabitViewModel> getHabits() {
    return _repository.getHabits();
  }

  List<TimeInvestmentHabitViewModel> getTodayHabits() {
    var today = getFrequencyDay(DateTime.now().weekday);
    return _repository
        .getHabitsByUserId(userService.getCurrentUser()!.id)
        .where((habit) {
      return habit.frequencyDays!.contains(today);
    }).toList();
  }

  List<TimeInvestmentHabitViewModel> getHabitsByUserId(int userId) {
    return _repository.getHabitsByUserId(userId);
  }

  FrequencyDay getFrequencyDay(int today) {
    switch (today) {
      case 1:
        return FrequencyDay.MONDAY;
      case 2:
        return FrequencyDay.TUESDAY;
      case 3:
        return FrequencyDay.WEDNESDAY;
      case 4:
        return FrequencyDay.THURSDAY;
      case 5:
        return FrequencyDay.FRIDAY;
      case 6:
        return FrequencyDay.SATURDAY;
      case 7:
        return FrequencyDay.SUNDAY;
      default:
        return FrequencyDay.MONDAY;
    }
  }
}
