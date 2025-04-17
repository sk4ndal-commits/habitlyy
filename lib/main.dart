import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:habitlyy/providers/habit_provider.dart';
import 'package:habitlyy/services/habits/ihabits_service.dart';
import 'package:habitlyy/views/homepage/homepage_view.dart';
import 'package:provider/provider.dart';
import 'package:habitlyy/service_locator.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(HabitsApp());
}

class HabitsApp extends StatefulWidget {
  @override
  _HabitsAppState createState() => _HabitsAppState();
}

class _HabitsAppState extends State<HabitsApp> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final habitsService = getIt<IHabitsService>();

    try {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) {
              final habitsProvider = HabitsProvider(habitsService);
              habitsProvider.initializeHabitsAsync(); // Initialize habits here
              return habitsProvider;
            },
          ),
        ],
        child: MaterialApp(
          themeMode: ThemeMode.system,
          darkTheme: ThemeData.dark(),
          theme: ThemeData.light(),
          home: HomePageView(),
          routes: {
            '/home': (_) => HomePageView(),
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
