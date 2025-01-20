import 'package:sqflite/sqflite.dart';
import '../../viewmodels/profile/user_viewmodel.dart';
import 'iuser_repository.dart';

class UserDBRepository implements IUserRepository {
  final Database _database;

  UserDBRepository(this._database);


  @override
  Future<void> addUserAsync(UserViewModel user) async {

    await _database.insert(
      'users',
      {
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'password': user.password,
        'photoUrl': user.photoUrl,
      },
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );
  }

  @override
  Future<void> updateUserAsync(UserViewModel user) async {

    await _database.update(
      'users',
      {
        'name': user.name,
        'email': user.email,
        'password': user.password,
        'photoUrl': user.photoUrl,
      },
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  @override
  Future<void> deleteUserAsync(int userId) async {

    await _database.delete(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  @override
  Future<UserViewModel?> getUserByIdAsync(int userId) async {

    final result = await _database.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (result.isNotEmpty) {
      final userRow = result.first;
      return UserViewModel(
        id: userRow['id'] as int,
        name: userRow['name'] as String,
        email: userRow['email'] as String,
        password: userRow['password'] as String,
        photoUrl: userRow['photoUrl'] as String?,
      );
    }
    return null;
  }

  @override
  Future<UserViewModel?> getUserByEmailAndPasswordAsync(
      String email, String password) async {

    final result = await _database.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      final userRow = result.first;
      return UserViewModel(
        id: userRow['id'] as int,
        name: userRow['name'] as String,
        email: userRow['email'] as String,
        password: userRow['password'] as String,
        photoUrl: userRow['photoUrl'] as String?,
      );
    }
    return null;
  }

  @override
  Future<List<UserViewModel>> getAllUsersAsync() async {

    final result = await _database.query('users');

    return result.map((userRow) {
      return UserViewModel(
        id: userRow['id'] as int,
        name: userRow['name'] as String,
        email: userRow['email'] as String,
        password: userRow['password'] as String,
        photoUrl: userRow['photoUrl'] as String?,
      );
    }).toList();
  }
}