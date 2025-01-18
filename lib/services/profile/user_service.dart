import 'package:habitlyy/services/profile/iuser_service.dart';
import 'package:habitlyy/viewmodels/profile/user_viewmodel.dart';

class UserService implements IUserService {
  final List<UserViewModel> _users = [];
  UserViewModel? _currentUser;

  void addUser(UserViewModel user) {
    _users.add(user);
  }

  void updateUser(UserViewModel updatedUser) {
    final index = _users.indexWhere((user) => user.id == updatedUser.id);
    if (index != -1) {
      _users[index] = updatedUser;
    }
  }

  void deleteUser(int userId) {
    _users.removeWhere((user) => user.id == userId);
  }

  UserViewModel? getCurrentUser() {
    return _currentUser;
  }

  UserViewModel? getUserById(int userId) {
    try {
      return _users.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }

  UserViewModel? login(String email, String password) {
    try {
      final user = _users.firstWhere(
        (user) => user.email == email && user.password == password,
      );
      _currentUser = user;
      return user;
    } catch (e) {
      return null;
    }
  }

  void logout() {
    _currentUser = null;
  }
}
