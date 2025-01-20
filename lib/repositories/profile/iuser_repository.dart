import '../../viewmodels/profile/user_viewmodel.dart';

abstract class IUserRepository {
  Future<void> addUserAsync(UserViewModel user);
  Future<void> updateUserAsync(UserViewModel user);
  Future<void> deleteUserAsync(int userId);
  Future<UserViewModel?> getUserByIdAsync(int userId);
  Future<UserViewModel?> getUserByEmailAndPasswordAsync(String email, String password);
  Future<List<UserViewModel>> getAllUsersAsync();
}