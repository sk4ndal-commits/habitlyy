import 'package:get_it/get_it.dart';
import 'package:habitlyy/repositories/habits_dummy_repository.dart';
import 'package:habitlyy/repositories/habits_repository.dart';
import 'package:habitlyy/services/habits_service.dart';


final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<IHabitsRepository>(() => HabitsDummyRepository());
  getIt.registerLazySingleton<IHabitsService>(() => HabitsService());
}
