import 'iuser_repository.dart';
import '../../viewmodels/profile/user_viewmodel.dart';

class UserRepository implements IUserRepository {
  final List<UserViewModel> _users = [];

  void addUser(UserViewModel user) {
    _users.add(user);
  }

  void updateUser(UserViewModel user) {
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
    }
  }

  void deleteUser(int userId) {
    _users.removeWhere((user) => user.id == userId);
  }

  UserViewModel? getUserById(int userId) {
    try {
      return _users.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }

  UserViewModel? getUserByEmailAndPassword(String email, String password) {
    try {
      return _users.firstWhere(
        (user) => user.email == email && user.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  List<UserViewModel> getAllUsers() {
    return _users;
  }
}