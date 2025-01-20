import 'package:habitlyy/services/profile/iuser_service.dart';
import 'package:habitlyy/viewmodels/profile/user_viewmodel.dart';

import '../../repositories/profile/iuser_repository.dart';

class UserService implements IUserService {
  final IUserRepository _userRepository;
  UserViewModel? _currentUser;

  UserService(this._userRepository);

  Future<void> addUserAsync(UserViewModel user) async {
    await _userRepository.addUserAsync(user);
  }

  Future<void> updateUserAsync(UserViewModel updatedUser) async {
    await _userRepository.updateUserAsync(updatedUser);
    if (_currentUser != null && _currentUser!.id == updatedUser.id) {
      _currentUser = updatedUser;
    }
  }

  Future<void> deleteUserAsync(int userId) async {
    await _userRepository.deleteUserAsync(userId);
  }

  UserViewModel? getCurrentUserAsync() {
    return _currentUser;
  }

  Future<UserViewModel?> getUserByIdAsync(int userId) async {
    return await _userRepository.getUserByIdAsync(userId);
  }

  Future<UserViewModel?> loginAsync(String email, String password) async {
    final user = await _userRepository.getUserByEmailAndPasswordAsync(email, password);
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