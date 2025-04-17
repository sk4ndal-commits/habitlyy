import 'package:habitlyy/enums/frequency_days.dart';
import '../../repositories/habits/habits_repository.dart';
import '../../viewmodels/habits/habit_viewmodel.dart';
import 'ihabits_service.dart';

/// Service class for managing habits
///
/// This service provides business logic for habit management operations.
/// It implements the [IHabitsService] interface and uses an [IHabitsRepository]
/// for data persistence.
class HabitsService implements IHabitsService {
  final IHabitsRepository _repository;

  /// Creates a new instance of HabitsService
  ///
  /// Requires an [IHabitsRepository] implementation for data access.
  HabitsService(this._repository);

  /// Adds a new habit
  ///
  /// Takes a [TimeInvestmentHabitViewModel] and persists it using the repository.
  @override
  Future<void> addHabitAsync(TimeInvestmentHabitViewModel habit) async {
    await _repository.addHabitAsync(habit);
  }

  /// Updates an existing habit
  ///
  /// Takes a [TimeInvestmentHabitViewModel] and updates its record using the repository.
  @override
  Future<void> updateHabitAsync(TimeInvestmentHabitViewModel habit) {
    return _repository.updateHabitAsync(habit);
  }

  /// Deletes a habit by its ID
  ///
  /// Takes a habit ID and removes the corresponding record using the repository.
  @override
  Future<void> deleteHabitAsync(int habitId) async {
    await _repository.deleteHabitAsync(habitId);
  }

  /// Retrieves all habits
  ///
  /// Returns a list of all [TimeInvestmentHabitViewModel] objects from the repository.
  @override
  Future<List<TimeInvestmentHabitViewModel>> getHabitsAsync() async {
    return await _repository.getHabitsAsync();
  }

  /// Retrieves habits scheduled for today
  ///
  /// Returns a list of [TimeInvestmentHabitViewModel] objects that are scheduled
  /// for the current day of the week based on their frequency settings.
  @override
  Future<List<TimeInvestmentHabitViewModel>> getTodayHabitsAsync() async {
    final today = getFrequencyDay(DateTime.now().weekday);

    final habits = (await this._repository.getHabitsAsync())
        .where((habit) => habit.frequencyDays?.contains(today) ?? false)
        .toList();

    return habits;
  }

  /// Retrieves habits for a specific user
  ///
  /// Takes a user ID and returns a list of [TimeInvestmentHabitViewModel] objects
  /// associated with that user.
  @override
  Future<List<TimeInvestmentHabitViewModel>> getHabitsByUserIdAsync(
      int userId) async {
    return await _repository.getHabitsByUserIdAsync(userId);
  }

  // Constant array of frequency days for efficient lookup
  static const List<FrequencyDay> _DAYS = [
    FrequencyDay.MONDAY,
    FrequencyDay.TUESDAY,
    FrequencyDay.WEDNESDAY,
    FrequencyDay.THURSDAY,
    FrequencyDay.FRIDAY,
    FrequencyDay.SATURDAY,
    FrequencyDay.SUNDAY
  ];

  /// Converts a weekday number to a FrequencyDay enum
  ///
  /// Takes a weekday number (1-7, where 1 is Monday) and returns the corresponding
  /// [FrequencyDay] enum value.
  FrequencyDay getFrequencyDay(int weekday) {
    return _DAYS[(weekday - 1) % 7];
  }

}
