import 'package:habitlyy/services/profile/iuser_service.dart';
import 'package:habitlyy/viewmodels/profile/user_viewmodel.dart';

import '../../repositories/profile/iuser_repository.dart';

class UserService implements IUserService {
  final IUserRepository _userRepository;
  UserViewModel? _currentUser;

  UserService(this._userRepository);

  Future<void> addUser(UserViewModel user) async {
    await _userRepository.addUser(user);
  }

  Future<void> updateUser(UserViewModel updatedUser) async {
    await _userRepository.updateUser(updatedUser);
    if (_currentUser != null && _currentUser!.id == updatedUser.id) {
      _currentUser = updatedUser;
    }
  }

  Future<void> deleteUser(int userId) async {
    await _userRepository.deleteUser(userId);
  }

  UserViewModel? getCurrentUser() {
    return _currentUser;
  }

  Future<UserViewModel?> getUserById(int userId) async {
    return await _userRepository.getUserById(userId);
  }

  Future<UserViewModel?> login(String email, String password) async {
    final user = await _userRepository.getUserByEmailAndPassword(email, password);
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