import 'package:flutter/material.dart';
import 'package:habitlyy/habits/views/habits_list_view.dart';

import '../generated/l10n.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    HomeWidget(),
    HabitsView(),
    ProfileWidget(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: S.of(context)?.navbar_home ?? '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: S.of(context)?.navbar_habits ?? '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: S.of(context)?.navbar_profile ?? '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent[800],
        onTap: _onTabSelected,
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Home'));
  }
}

class NotificationsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Notifications'));
  }
}

class ProfileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Profile'));
  }
}
