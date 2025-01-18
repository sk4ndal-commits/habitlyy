import 'package:habitlyy/enums/frequency_days.dart';
import '../../repositories/habits/habits_repository.dart';
import '../../viewmodels/habits/habit_viewmodel.dart';
import '../profile/iuser_service.dart';
import 'ihabits_service.dart';

class HabitsService implements IHabitsService {
  final IHabitsRepository _repository;
  final IUserService _userService;

  HabitsService(this._repository, this._userService);

  void addHabit(TimeInvestmentHabitViewModel habit) {
    _repository.addHabit(habit);
  }

  void removeHabit(int habitId) {
    _repository.deleteHabit(habitId);
  }

  List<TimeInvestmentHabitViewModel> getHabits() {
    return _repository.getHabits();
  }

  List<TimeInvestmentHabitViewModel> getTodayHabits() {
    final currentUser = _userService.getCurrentUser();
    if (currentUser == null) {
      return [];
    }

    final today = getFrequencyDay(DateTime.now().weekday);
    return _repository
        .getHabitsByUserId(currentUser.id)
        .where((habit) => habit.frequencyDays?.contains(today) ?? false)
        .toList();
  }

  List<TimeInvestmentHabitViewModel> getHabitsByUserId(int userId) {
    return _repository.getHabitsByUserId(userId);
  }

  FrequencyDay getFrequencyDay(int weekday) {
    const days = [
      FrequencyDay.MONDAY,
      FrequencyDay.TUESDAY,
      FrequencyDay.WEDNESDAY,
      FrequencyDay.THURSDAY,
      FrequencyDay.FRIDAY,
      FrequencyDay.SATURDAY,
      FrequencyDay.SUNDAY
    ];
    return days[(weekday - 1) % 7];
  }
}
