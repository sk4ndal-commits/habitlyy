
import '../../viewmodels/profile/user_viewmodel.dart';

abstract class IUserService {
  Future<void> addUser(UserViewModel user);
  Future<void> updateUser(UserViewModel user);
  Future<void> deleteUser(int userId);
  UserViewModel? getCurrentUser();
  Future<UserViewModel?> login(String email, String password);
  Future<UserViewModel?> getUserById(int userId);
  void logout();
}
