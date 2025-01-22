import 'package:flutter/material.dart';
import 'package:habitlyy/service_locator.dart';
import 'package:provider/provider.dart';

import '../../providers/habit_provider.dart';
import '../../services/profile/iuser_service.dart';

class LoginView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/showcase');
              },
              child: Text('See what the app offers'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text;
                final password = passwordController.text;
                final userService = getIt<IUserService>();
                final user = await userService.loginAsync(email, password);
                if (user != null) {
                  final habitsProvider =
                      Provider.of<HabitsProvider>(context, listen: false);
                  await habitsProvider.initializeHabitsAsync(user.id);

                  Navigator.of(context).pushReplacementNamed('/home');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid credentials')),
                  );
                }
              },
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/register');
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
