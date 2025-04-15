import 'package:get_it/get_it.dart';
import 'package:habitlyy/database/database_helper.dart';
import 'package:habitlyy/repositories/habits/habits_db_repository.dart';
import 'package:habitlyy/repositories/habits/habits_repository.dart';

import 'services/habits/habits_service.dart';
import 'services/habits/ihabits_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  final dbHelper = DatabaseHelper();
  final database = await dbHelper.database;

  getIt.registerLazySingleton<IHabitsRepository>(
      () => HabitsDBRepository(database));

  getIt.registerLazySingleton<IHabitsService>(
        () => HabitsService(getIt<IHabitsRepository>()),
  );
}
