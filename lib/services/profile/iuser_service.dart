
import '../../viewmodels/profile/user_viewmodel.dart';

abstract class IUserService {
  void addUser(UserViewModel user);
  void updateUser(UserViewModel user);
  void deleteUser(int userId);
  UserViewModel? getCurrentUser();
  UserViewModel? login(String email, String password);
  UserViewModel? getUserById(int userId);
  void logout();
}
