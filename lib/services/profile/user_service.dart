import 'package:habitlyy/services/profile/iuser_service.dart';
import 'package:habitlyy/viewmodels/profile/user_viewmodel.dart';

import '../../repositories/profile/iuser_repository.dart';

class UserService implements IUserService {
  final IUserRepository _userRepository;
  UserViewModel? _currentUser;

  UserService(this._userRepository);

  void addUser(UserViewModel user) {
    _userRepository.addUser(user);
  }

  void updateUser(UserViewModel updatedUser) {
    _userRepository.updateUser(updatedUser);
    if (_currentUser != null && _currentUser!.id == updatedUser.id) {
      _currentUser = updatedUser;
    }
  }

  void deleteUser(int userId) {
    _userRepository.deleteUser(userId);
  }

  UserViewModel? getCurrentUser() {
    return _currentUser;
  }

  UserViewModel? getUserById(int userId) {
    return _userRepository.getUserById(userId);
  }

  UserViewModel? login(String email, String password) {
    final user = _userRepository.getUserByEmailAndPassword(email, password);
    if (user == null) {
      return null;
    }
    _currentUser = user;
    return user;
  }

  void logout() {
    _currentUser = null;
  }
}
