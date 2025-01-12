import 'package:flutter/material.dart';

import '../views/dashboard/dashboard_view.dart';
import '../views/habits/habits_list_view.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    DashboardView(),
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
      appBar: AppBar(
          title: Row(
        children: [
          Text('habitlyy',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              )),
          SizedBox(width: 8.0),
          Icon(Icons.task, color: Colors.green)
        ],
      )),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onTabSelected,
      ),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Profile'));
  }
}
