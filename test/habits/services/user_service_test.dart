import 'package:flutter_test/flutter_test.dart';
import 'package:habitlyy/repositories/profile/iuser_repository.dart';
import 'package:habitlyy/services/profile/user_service.dart';
import 'package:habitlyy/viewmodels/profile/user_viewmodel.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late UserService userService;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    userService = UserService(mockUserRepository);
  });

  group('UserService', () {
    test('adds a user', () {
      final user = UserViewModel(
          id: 1,
          name: 'Test User',
          email: 'test@example.com',
          password: 'password',
          photoUrl: 'http://example.com/photo.jpg',
          habitIds: []);

      userService.addUser(user);

      verify(mockUserRepository.addUser(user)).called(1);
    });

    test('updates a user', () {
      final updatedUser = UserViewModel(
          id: 1,
          name: 'Updated User',
          email: 'updated@example.com',
          password: 'password',
          photoUrl: 'http://example.com/photo.jpg',
          habitIds: []);

      userService.updateUser(updatedUser);

      verify(mockUserRepository.updateUser(updatedUser)).called(1);
    });

    test('deletes a user', () {
      final userId = 1;

      userService.deleteUser(userId);

      verify(mockUserRepository.deleteUser(userId)).called(1);
    });

    test('gets current user', () {
      final user = UserViewModel(
          id: 1,
          name: 'Test User',
          email: 'test@example.com',
          password: 'password',
          photoUrl: 'http://example.com/photo.jpg',
          habitIds: []);

      // Define what the mock repository should do when addUser is called
      when(mockUserRepository.addUser(user)).thenAnswer((_) async {});

      // Add the user to the repository
      userService.addUser(user);

      // Define what the mock repository should do when getUserByEmailAndPassword is called
      when(mockUserRepository.getUserByEmailAndPassword(
              user.email, user.password))
          .thenReturn(user);

      // Log in the user
      userService.login(user.email, user.password);

      final result = userService.getCurrentUser();

      expect(result, user);
    });

    test('gets user by ID', () {
      final userId = 1;
      final user = UserViewModel(
          id: userId,
          name: 'Test User',
          email: 'test@example.com',
          password: 'password',
          photoUrl: 'http://example.com/photo.jpg',
          habitIds: []);

      when(mockUserRepository.getUserById(userId)).thenReturn(user);

      final result = userService.getUserById(userId);

      expect(result, user);
      verify(mockUserRepository.getUserById(userId)).called(1);
    });

    test('logs in a user', () {
      final email = 'test@example.com';
      final password = 'password';
      final user = UserViewModel(
          id: 1,
          name: 'Test User',
          email: email,
          password: password,
          photoUrl: 'http://example.com/photo.jpg',
          habitIds: []);

      when(mockUserRepository.getUserByEmailAndPassword(email, password))
          .thenReturn(user);

      final result = userService.login(email, password);

      expect(result, user);
      expect(userService.getCurrentUser(), user);
      verify(mockUserRepository.getUserByEmailAndPassword(email, password))
          .called(1);
    });

    test('logs out a user', () {
      final email = 'test@example.com';
      final password = 'password';
      final user = UserViewModel(
          id: 1,
          name: 'Test User',
          email: email,
          password: password,
          photoUrl: 'http://example.com/photo.jpg',
          habitIds: []);

      when(mockUserRepository.getUserByEmailAndPassword(email, password))
          .thenReturn(user);

      userService.login(email, password);
      userService.logout();

      expect(userService.getCurrentUser(), isNull);
    });
  });
}
