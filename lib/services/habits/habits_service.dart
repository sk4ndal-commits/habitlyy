import 'package:habitlyy/enums/frequency_days.dart';
import '../../repositories/habits/habits_repository.dart';
import '../../viewmodels/habits/habit_viewmodel.dart';
import '../profile/iuser_service.dart';
import 'ihabits_service.dart';

class HabitsService implements IHabitsService {
  final IHabitsRepository _repository;
  final IUserService _userService;

  HabitsService(this._repository, this._userService);

  Future<void> addHabit(TimeInvestmentHabitViewModel habit) async {
    await _repository.addHabit(habit);
  }

  Future<void> removeHabit(int habitId) async {
    await _repository.deleteHabit(habitId);
  }

  Future<List<TimeInvestmentHabitViewModel>> getHabits() async {
    return await _repository.getHabits();
  }

  Future<List<TimeInvestmentHabitViewModel>> getTodayHabits() async {
    final currentUser = _userService.getCurrentUser();
    if (currentUser == null) {
      return [];
    }

    final today = getFrequencyDay(DateTime.now().weekday);
    final habitsByUser = await _repository.getHabitsByUserId(currentUser.id);

    return habitsByUser
        .where((habit) => habit.frequencyDays?.contains(today) ?? false)
        .toList();
  }

  Future<List<TimeInvestmentHabitViewModel>> getHabitsByUserId(
      int userId) async {
    return await _repository.getHabitsByUserId(userId);
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
