
import '../../viewmodels/profile/user_viewmodel.dart';

abstract class IUserService {
  Future<void> addUserAsync(UserViewModel user);
  Future<void> updateUserAsync(UserViewModel user);
  Future<void> deleteUserAsync(int userId);
  UserViewModel? getCurrentUserAsync();
  Future<UserViewModel?> loginAsync(String email, String password);
  Future<UserViewModel?> getUserByIdAsync(int userId);
  void logout();
}
