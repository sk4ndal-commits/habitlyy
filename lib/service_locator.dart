import 'package:get_it/get_it.dart';
import 'package:habitlyy/database/db_config.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
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
  final database = await initializeDatabase();

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

Future<Database> initializeDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, DBConfig().DBName);

  return await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      // Create the users table
      await db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          email TEXT UNIQUE,
          password TEXT,
          photoUrl TEXT
        )
      ''');

      // Create the habits table
      await db.execute('''
        CREATE TABLE habits (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          priority TEXT,
          startDate TEXT,
          deadline TEXT,
          targetHours REAL,
          frequencyDays TEXT,
          userId INTEGER,
          FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
        )
      ''');
    },
  );
}
