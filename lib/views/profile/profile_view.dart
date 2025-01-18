import 'package:flutter/material.dart';
import 'package:habitlyy/service_locator.dart';
import 'package:habitlyy/services/profile/iuser_service.dart';
import 'package:habitlyy/viewmodels/profile/user_viewmodel.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userService = getIt<IUserService>();
    final user = userService.getCurrentUser();

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Profile')),
        body: Center(child: Text('User not found')),
      );
    }

    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final avatarUrlController = TextEditingController(text: user.photoUrl);
    final passwordController = TextEditingController(text: user.password);

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
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
              controller: avatarUrlController,
              decoration: InputDecoration(labelText: 'Avatar URL'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                userService.updateUser(UserViewModel(
                  id: user.id,
                  name: nameController.text,
                  email: emailController.text,
                  password: passwordController.text,
                  photoUrl: avatarUrlController.text,
                  habitIds: user.habitIds,
                ));
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
