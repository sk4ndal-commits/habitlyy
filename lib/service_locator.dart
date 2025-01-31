import 'package:get_it/get_it.dart';
import 'package:habitlyy/database/database_helper.dart';
import 'package:habitlyy/repositories/habits/habits_db_repository.dart';
import 'package:habitlyy/repositories/habits/habits_repository.dart';
import 'package:habitlyy/repositories/profile/iuser_repository.dart';
import 'package:habitlyy/repositories/profile/user_db_repository.dart';
import 'package:habitlyy/services/habits/ihabits_service.dart';
import 'package:habitlyy/services/habits/habits_service.dart';
import 'package:habitlyy/services/profile/iuser_service.dart';
import 'package:habitlyy/services/profile/user_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  final dbHelper = DatabaseHelper();
  final database = await dbHelper.database;

  getIt.registerLazySingleton<IHabitsRepository>(
      () => HabitsDBRepository(database));
  getIt
      .registerLazySingleton<IUserRepository>(() => UserDBRepository(database));

  getIt.registerLazySingleton<IUserService>(
    () => UserService(getIt<IUserRepository>()),
  );
  getIt.registerLazySingleton<IHabitsService>(
    () => HabitsService(getIt<IHabitsRepository>(), getIt<IUserService>()),
  );
}
