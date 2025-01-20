import 'package:flutter/material.dart';
import 'package:habitlyy/service_locator.dart';
import 'package:habitlyy/viewmodels/habits/habit_viewmodel.dart';
import 'package:habitlyy/views/dashboard/dashboard_list_item_view.dart';
import '../../services/habits/ihabits_service.dart';

class DashboardListView extends StatefulWidget {
  @override
  _DashboardListViewState createState() => _DashboardListViewState();
}

class _DashboardListViewState extends State<DashboardListView> {
  late Future<List<TimeInvestmentHabitViewModel>> _todayHabitsFuture;

  @override
  void initState() {
    super.initState();
    _fetchTodayHabits(); // Initialize the future
  }

  // Fetch today's habits asynchronously
  Future<void> _fetchTodayHabits() async {
    final habitsService = getIt<IHabitsService>();
    _todayHabitsFuture = habitsService.getTodayHabitsAsync();
    await _todayHabitsFuture;
  }

  // Filters and sorts the habits (not async since we already fetched the data)
  List<TimeInvestmentHabitViewModel> _filterAndSortHabits(
      List<TimeInvestmentHabitViewModel> habits) {
    final filteredHabits = habits
        .where((habit) => habit.investedHours < habit.targetHours)
        .toList();
    filteredHabits.sort((a, b) => a.priority.index.compareTo(b.priority.index));
    return filteredHabits;
  }

  // Builds the widget for the filtered habits list
  Widget _buildHabitList(List<TimeInvestmentHabitViewModel> habits) {
    return ListView.builder(
      itemCount: habits.length,
      itemBuilder: (context, index) {
        final habit = habits[index];
        return DashboardListItemView(
          habit: habit,
          onHabitUpdated: (updateHabit) {
            // Refresh habits when updated
            setState(() {
              habits[index] = updateHabit;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TimeInvestmentHabitViewModel>>(
      future: _todayHabitsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          ); // Show loading indicator while fetching data
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          ); // Error handling
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('No habits for today'),
          ); // Handle no data case
        } else {
          // Filter and sort the habits before rendering
          final filteredHabits = _filterAndSortHabits(snapshot.data!);
          return _buildHabitList(filteredHabits);
        }
      },
    );
  }
}
