import '../../viewmodels/profile/user_viewmodel.dart';

abstract class IUserRepository {
  void addUser(UserViewModel user);
  void updateUser(UserViewModel user);
  void deleteUser(int userId);
  UserViewModel? getUserById(int userId);
  UserViewModel? getUserByEmailAndPassword(String email, String password);
  List<UserViewModel> getAllUsers();
}