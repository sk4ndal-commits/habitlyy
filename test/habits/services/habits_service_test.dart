import 'package:flutter_test/flutter_test.dart';
import 'package:habitlyy/habits/repositories/habits_repository.dart';
import 'package:habitlyy/habits/services/habits_service.dart';
import 'package:habitlyy/habits/viewmodels/habit_viewmodel.dart';
import 'package:habitlyy/service_locator.dart';
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
      final habit = HabitViewModel(
        id: 1,
        title: 'Test Habit',
        description: 'Test Description',
        startDate: DateTime.now(),
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
        HabitViewModel(
          id: 1,
          title: 'Test Habit',
          description: 'Test Description',
          startDate: DateTime.now(),
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
      final habit1 = HabitViewModel(
        id: 1,
        title: 'Habit 1',
        description: 'Description 1',
        startDate: DateTime.now(),
      );
      final habit2 = HabitViewModel(
        id: 2,
        title: 'Habit 2',
        description: 'Description 2',
        startDate: DateTime.now(),
      );

      habitsService.addHabit(habit1);
      habitsService.addHabit(habit2);

      // Verify the repository's addHabit method is called with each habit
      verify(mockRepository.addHabit(habit1)).called(1);
      verify(mockRepository.addHabit(habit2)).called(1);
    });
  });
}