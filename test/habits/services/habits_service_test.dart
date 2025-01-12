import 'package:flutter_test/flutter_test.dart';
import 'package:habitlyy/enums/goal_priority.dart';
import 'package:habitlyy/repositories/habits_repository.dart';
import 'package:habitlyy/service_locator.dart';
import 'package:habitlyy/services/habits_service.dart';
import 'package:habitlyy/viewmodels/habit_viewmodel.dart';
import 'package:mockito/mockito.dart';

class MockHabitsRepository extends Mock implements IHabitsRepository {}

void main() {
  late HabitsService habitsService;
  late MockHabitsRepository mockRepository;

  setUp(() {
    setupLocator();
    getIt.allowReassignment = true;

    mockRepository = MockHabitsRepository();
    getIt.registerLazySingleton<IHabitsRepository>(() => mockRepository);

    habitsService = HabitsService();
  });

  group('HabitsService', () {
    test('adds a habit', () {
      final habit = TimeInvestmentHabitViewModel(
        id: 1,
        title: 'Test Habit',
        priority: GoalPriority.LOW,
        startDate: DateTime.now(),
        deadline: DateTime.now().add(Duration(days: 7)),
        targetHours: 10.0,
      );

      habitsService.addHabit(habit);

      verify(mockRepository.addHabit(habit)).called(1);
    });

    test('removes a habit', () {
      final habitId = 1;

      habitsService.removeHabit(habitId);

      verify(mockRepository.removeHabit(habitId)).called(1);
    });

    test('gets all habits', () {
      final habits = [
        TimeInvestmentHabitViewModel(
          id: 1,
          title: 'Test Habit',
          priority: GoalPriority.LOW,
          startDate: DateTime.now(),
          deadline: DateTime.now().add(Duration(days: 7)),
          targetHours: 10.0,
        )
      ];

      when(mockRepository.getHabits()).thenReturn(habits);

      final result = habitsService.getHabits();

      expect(result, habits);

      verify(mockRepository.getHabits()).called(1);
    });

    test('removes a non-existent habit', () {
      final habitId = 999;

      when(mockRepository.removeHabit(habitId)).thenReturn(null);

      habitsService.removeHabit(habitId);

      verify(mockRepository.removeHabit(habitId)).called(1);
    });

    test('adds multiple habits', () {
      final habit1 = TimeInvestmentHabitViewModel(
        id: 1,
        title: 'Habit 1',
        priority: GoalPriority.LOW,
        startDate: DateTime.now(),
        deadline: DateTime.now().add(Duration(days: 7)),
        targetHours: 10.0,
      );
      final habit2 = TimeInvestmentHabitViewModel(
        id: 2,
        title: 'Habit 2',
        priority: GoalPriority.MEDIUM,
        startDate: DateTime.now(),
        deadline: DateTime.now().add(Duration(days: 7)),
        targetHours: 20.0,
      );

      habitsService.addHabit(habit1);
      habitsService.addHabit(habit2);

      // Verify the repository's addHabit method is called with each habit
      verify(mockRepository.addHabit(habit1)).called(1);
      verify(mockRepository.addHabit(habit2)).called(1);
    });
  });
}