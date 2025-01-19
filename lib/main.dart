import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:habitlyy/providers/habit_provider.dart';
import 'package:habitlyy/services/profile/iuser_service.dart';
import 'package:habitlyy/views/homepage/homepage_view.dart';
import 'package:habitlyy/views/login/login_view.dart';
import 'package:habitlyy/views/login/register_view.dart';
import 'package:habitlyy/views/showcase/app_showcase_screen.dart';
import 'package:provider/provider.dart';
import 'package:habitlyy/service_locator.dart';
import 'generated/l10n.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late final IUserService _userService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _userService = getIt<IUserService>();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      _userService.logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = getIt<IUserService>();

    try {
      final currentUser = userService.getCurrentUser();
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HabitsProvider()),
        ],
        child: MaterialApp(
          themeMode: ThemeMode.system,
          darkTheme: ThemeData.dark(),
          theme: ThemeData.light(),
          home: currentUser == null ? LoginView() : HomePageView(),
          routes: {
            '/home': (_) => HomePageView(),
            '/login': (_) => LoginView(),
            '/register': (_) => RegisterView(),
            '/showcase': (_) => AppShowcaseScreen(),
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
    } catch (e) {
      print('Error while retrieving current user: $e');
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child:
                Text('An unexpected error occurred. Please restart the app.'),
          ),
        ),
      );
    }
  }
}
