import 'package:flutter/material.dart';
import 'package:habitlyy/service_locator.dart';

import '../../services/profile/iuser_service.dart';
import '../../viewmodels/profile/user_viewmodel.dart';

class RegisterView extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text;
                final email = emailController.text;
                final password = passwordController.text;
                final confirmPassword = confirmPasswordController.text;

                if (password != confirmPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Passwords do not match')),
                  );
                  return;
                }

                final userService = getIt<IUserService>();

                final newUser = UserViewModel(
                  id: DateTime.now().millisecondsSinceEpoch,
                  name: name,
                  email: email,
                  password: password,
                  photoUrl: '',
                );

                userService.addUserAsync(newUser);
                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
