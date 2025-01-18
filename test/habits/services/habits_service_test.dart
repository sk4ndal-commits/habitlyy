import 'package:flutter_test/flutter_test.dart';
import 'package:habitlyy/enums/habit_priority.dart';
import 'package:habitlyy/repositories/habits/habits_repository.dart';
import 'package:habitlyy/service_locator.dart';
import 'package:habitlyy/services/habits/habits_service.dart';
import 'package:habitlyy/services/profile/iuser_service.dart';
import 'package:habitlyy/viewmodels/habits/habit_viewmodel.dart';
import 'package:mockito/mockito.dart';

class MockHabitsRepository extends Mock implements IHabitsRepository {}

class MockUserService extends Mock implements IUserService {}

void main() {
  late HabitsService habitsService;
  late MockHabitsRepository mockRepository;
  late MockUserService mockUserService;

  setUp(() {
    setupLocator();
    getIt.allowReassignment = true;

    mockRepository = MockHabitsRepository();
    mockUserService = MockUserService();
    getIt.registerLazySingleton<IHabitsRepository>(() => mockRepository);
    getIt.registerLazySingleton<IUserService>(() => mockUserService);

    habitsService = HabitsService(mockRepository, mockUserService);
  });

  group('HabitsService', () {
    test('adds a habit', () {
      final habit = TimeInvestmentHabitViewModel(
          id: 1,
          title: 'Test Habit',
          priority: HabitPriority.LOW,
          startDate: DateTime.now(),
          deadline: DateTime.now().add(Duration(days: 7)),
          targetHours: 10.0,
          frequencyDays: null,
          userId: 1);

      habitsService.addHabit(habit);

      verify(mockRepository.addHabit(habit)).called(1);
    });

    test('removes a habit', () {
      final habitId = 1;

      habitsService.removeHabit(habitId);

      verify(mockRepository.deleteHabit(habitId)).called(1);
    });

    test('gets all habits', () {
      final habits = [
        TimeInvestmentHabitViewModel(
            id: 1,
            title: 'Test Habit',
            priority: HabitPriority.LOW,
            startDate: DateTime.now(),
            deadline: DateTime.now().add(Duration(days: 7)),
            targetHours: 10.0,
            frequencyDays: null,
            userId: 1)
      ];

      // Define what the mock repository should return when getHabits is called
      when(mockRepository.getHabits()).thenReturn(habits);

      // Call the method to get habits
      final result = habitsService.getHabits();

      // Verify the result and the interaction with the mock repository
      expect(result, habits);
      verify(mockRepository.getHabits()).called(1);
    });

    test('removes a non-existent habit', () {
      final habitId = 999;

      when(mockRepository.deleteHabit(habitId)).thenReturn(null);

      habitsService.removeHabit(habitId);

      verify(mockRepository.deleteHabit(habitId)).called(1);
    });

    test('adds multiple habits', () {
      final habit1 = TimeInvestmentHabitViewModel(
          id: 1,
          title: 'Habit 1',
          priority: HabitPriority.LOW,
          startDate: DateTime.now(),
          deadline: DateTime.now().add(Duration(days: 7)),
          targetHours: 10.0,
          frequencyDays: null,
          userId: 1);
      final habit2 = TimeInvestmentHabitViewModel(
          id: 2,
          title: 'Habit 2',
          priority: HabitPriority.MEDIUM,
          startDate: DateTime.now(),
          deadline: DateTime.now().add(Duration(days: 7)),
          targetHours: 20.0,
          frequencyDays: null,
          userId: 1);

      habitsService.addHabit(habit1);
      habitsService.addHabit(habit2);

      // Verify the repository's addHabit method is called with each habit
      verify(mockRepository.addHabit(habit1)).called(1);
      verify(mockRepository.addHabit(habit2)).called(1);
    });

    test('gets habits by user ID', () {
      final userId = 1;
      final habits = [
        TimeInvestmentHabitViewModel(
            id: 1,
            title: 'Test Habit',
            priority: HabitPriority.LOW,
            startDate: DateTime.now(),
            deadline: DateTime.now().add(Duration(days: 7)),
            targetHours: 10.0,
            frequencyDays: null,
            userId: userId)
      ];

      when(mockRepository.getHabitsByUserId(userId)).thenReturn(habits);

      final result = habitsService.getHabitsByUserId(userId);

      expect(result, habits);

      verify(mockRepository.getHabitsByUserId(userId)).called(1);
    });
  });
}
