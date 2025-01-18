import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:habitlyy/providers/habit_provider.dart';
import 'package:habitlyy/services/profile/iuser_service.dart';
import 'package:habitlyy/views/homepage/homepage_view.dart';
import 'package:habitlyy/views/login/login_view.dart';
import 'package:habitlyy/views/login/register_view.dart';
import 'package:provider/provider.dart';
import 'package:habitlyy/service_locator.dart';
import 'generated/l10n.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = getIt<IUserService>();


    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HabitsProvider()),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.system,
        darkTheme: ThemeData.dark(),
        theme: ThemeData.light(),
        home: userService.getCurrentUser() == null ? LoginView() : HomePageView(),
        routes: {
          '/home': (_) => HomePageView(),
          '/login': (_) => LoginView(),
          '/register': (_) => RegisterView(),
        },
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
      ),
    );
  }
}