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
    await _repository.addHabit(habit);
  }

  @override
  Future<void> updateHabitAsync(TimeInvestmentHabitViewModel habit) {
    return _repository.updateHabit(habit);
  }

  @override
  Future<void> deleteHabitAsync(int habitId) async {
    await _repository.deleteHabit(habitId);
  }

  @override
  Future<List<TimeInvestmentHabitViewModel>> getHabitsAsync() async {
    return await _repository.getHabits();
  }

  @override
  Future<List<TimeInvestmentHabitViewModel>> getTodayHabitsAsync() async {
    final currentUser = _userService.getCurrentUser();
    if (currentUser == null) {
      return [];
    }

    final today = getFrequencyDay(DateTime.now().weekday);
    final habitsByUser = await _repository.getHabitsByUserId(currentUser.id);

    final habits = habitsByUser
        .where((habit) => habit.frequencyDays?.contains(today) ?? false)
        .toList();

    return habits;
  }

  @override
  Future<List<TimeInvestmentHabitViewModel>> getHabitsByUserIdAsync(
      int userId) async {
    return await _repository.getHabitsByUserId(userId);
  }

  @override
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
