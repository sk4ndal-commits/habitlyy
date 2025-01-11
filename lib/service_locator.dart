import 'package:get_it/get_it.dart';
import 'package:habitlyy/habits/repositories/habits_dummy_repository.dart';
import 'package:habitlyy/habits/services/habits_service.dart';

import 'habits/repositories/habits_repository.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<IHabitsRepository>(() => HabitsDummyRepository());
  getIt.registerLazySingleton<IHabitsService>(() => HabitsService());
}
