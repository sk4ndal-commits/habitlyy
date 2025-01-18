import 'package:flutter_test/flutter_test.dart';
import 'package:habitlyy/viewmodels/profile/user_viewmodel.dart';
import 'package:habitlyy/repositories/profile/user_repository.dart';

void main() {
  late UserRepository userRepository;

  setUp(() {
    userRepository = UserRepository();
  });

  test('adds a user', () {
    final user = UserViewModel(
      id: 1,
      name: 'Test User',
      email: 'test@example.com',
      password: 'password',
      photoUrl: 'http://example.com/photo.jpg',
      habitIds: [],
    );

    userRepository.addUser(user);

    expect(userRepository.getAllUsers(), contains(user));
  });

  test('updates a user', () {
    final user = UserViewModel(
      id: 1,
      name: 'Test User',
      email: 'test@example.com',
      password: 'password',
      photoUrl: 'http://example.com/photo.jpg',
      habitIds: [],
    );

    userRepository.addUser(user);

    final updatedUser = UserViewModel(
      id: 1,
      name: 'Updated User',
      email: 'updated@example.com',
      password: 'newpassword',
      photoUrl: 'http://example.com/newphoto.jpg',
      habitIds: [],
    );

    userRepository.updateUser(updatedUser);

    expect(userRepository.getUserById(1), equals(updatedUser));
  });

  test('deletes a user', () {
    final user = UserViewModel(
      id: 1,
      name: 'Test User',
      email: 'test@example.com',
      password: 'password',
      photoUrl: 'http://example.com/photo.jpg',
      habitIds: [],
    );

    userRepository.addUser(user);
    userRepository.deleteUser(1);

    expect(userRepository.getUserById(1), isNull);
  });

  test('gets user by ID', () {
    final user = UserViewModel(
      id: 1,
      name: 'Test User',
      email: 'test@example.com',
      password: 'password',
      photoUrl: 'http://example.com/photo.jpg',
      habitIds: [],
    );

    userRepository.addUser(user);

    final result = userRepository.getUserById(1);

    expect(result, equals(user));
  });

  test('gets user by email and password', () {
    final user = UserViewModel(
      id: 1,
      name: 'Test User',
      email: 'test@example.com',
      password: 'password',
      photoUrl: 'http://example.com/photo.jpg',
      habitIds: [],
    );

    userRepository.addUser(user);

    final result = userRepository.getUserByEmailAndPassword(
        'test@example.com', 'password');

    expect(result, equals(user));
  });

  test('gets all users', () {
    final user1 = UserViewModel(
      id: 1,
      name: 'Test User 1',
      email: 'test1@example.com',
      password: 'password1',
      photoUrl: 'http://example.com/photo1.jpg',
      habitIds: [],
    );

    final user2 = UserViewModel(
      id: 2,
      name: 'Test User 2',
      email: 'test2@example.com',
      password: 'password2',
      photoUrl: 'http://example.com/photo2.jpg',
      habitIds: [],
    );

    userRepository.addUser(user1);
    userRepository.addUser(user2);

    final result = userRepository.getAllUsers();

    expect(result, containsAll([user1, user2]));
  });
}
