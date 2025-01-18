import 'package:get_it/get_it.dart';
import 'package:habitlyy/repositories/habits/habits_dummy_repository.dart';
import 'package:habitlyy/repositories/habits/habits_repository.dart';
import 'package:habitlyy/repositories/profile/iuser_repository.dart';
import 'package:habitlyy/repositories/profile/user_repository.dart';
import 'package:habitlyy/services/habits/ihabits_service.dart';
import 'package:habitlyy/services/habits/habits_service.dart';
import 'package:habitlyy/services/profile/iuser_service.dart';
import 'package:habitlyy/services/profile/user_service.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<IHabitsRepository>(() => HabitsDummyRepository());
  getIt.registerLazySingleton<IUserRepository>(() => UserRepository());

  getIt.registerLazySingleton<IUserService>(
      () => UserService(getIt<IUserRepository>()));
  getIt.registerLazySingleton<IHabitsService>(
      () => HabitsService(getIt<IHabitsRepository>(), getIt<IUserService>()));
}
