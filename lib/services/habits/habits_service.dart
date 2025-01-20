import 'package:habitlyy/enums/frequency_days.dart';
import '../../repositories/habits/habits_repository.dart';
import '../../viewmodels/habits/habit_viewmodel.dart';
import '../profile/iuser_service.dart';
import 'ihabits_service.dart';

class HabitsService implements IHabitsService {
  final IHabitsRepository _repository;
  final IUserService _userService;

  HabitsService(this._repository, this._userService);

  @override
  Future<void> addHabitAsync(TimeInvestmentHabitViewModel habit) async {
    await _repository.addHabitAsync(habit);
  }

  @override
  Future<void> updateHabitAsync(TimeInvestmentHabitViewModel habit) {
    return _repository.updateHabitAsync(habit);
  }

  @override
  Future<void> deleteHabitAsync(int habitId) async {
    await _repository.deleteHabitAsync(habitId);
  }

  @override
  Future<List<TimeInvestmentHabitViewModel>> getHabitsAsync() async {
    return await _repository.getHabitsAsync();
  }

  @override
  Future<List<TimeInvestmentHabitViewModel>> getTodayHabitsAsync() async {
    final currentUser = _userService.getCurrentUserAsync();
    if (currentUser == null) {
      return [];
    }

    final today = getFrequencyDay(DateTime.now().weekday);
    final habitsByUser = await _repository.getHabitsByUserIdAsync(currentUser.id);

    final habits = habitsByUser
        .where((habit) => habit.frequencyDays?.contains(today) ?? false)
        .toList();

    return habits;
  }

  @override
  Future<List<TimeInvestmentHabitViewModel>> getHabitsByUserIdAsync(
      int userId) async {
    return await _repository.getHabitsByUserIdAsync(userId);
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
