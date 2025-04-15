import 'package:habitlyy/enums/frequency_days.dart';
import '../../repositories/habits/habits_repository.dart';
import '../../viewmodels/habits/habit_viewmodel.dart';
import 'ihabits_service.dart';

class HabitsService implements IHabitsService {
  final IHabitsRepository _repository;

  HabitsService(this._repository);

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
    final today = getFrequencyDay(DateTime.now().weekday);

    final habits = (await this._repository.getHabitsAsync())
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
