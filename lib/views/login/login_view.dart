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
      body: Center(
        // Wrap with Center widget
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // Ensures the Column takes minimum space
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final email = emailController.text;
                      final password = passwordController.text;
                      final userService = getIt<IUserService>();
                      final user =
                          await userService.loginAsync(email, password);
                      if (user != null) {
                        final habitsProvider =
                            Provider.of<HabitsProvider>(context, listen: false);
                        await habitsProvider.initializeHabitsAsync();

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
              SizedBox(height: 64.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/showcase');
                },
                child: Text(
                  'See what the app offers',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
