import '../../viewmodels/profile/user_viewmodel.dart';

abstract class IUserRepository {
  Future<void> addUser(UserViewModel user);
  Future<void> updateUser(UserViewModel user);
  Future<void> deleteUser(int userId);
  Future<UserViewModel?> getUserById(int userId);
  Future<UserViewModel?> getUserByEmailAndPassword(String email, String password);
  Future<List<UserViewModel>> getAllUsers();
}