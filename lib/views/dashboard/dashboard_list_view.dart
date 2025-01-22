import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habitlyy/viewmodels/habits/habit_viewmodel.dart';
import 'package:habitlyy/views/dashboard/dashboard_list_item_view.dart';
import '../../providers/habit_provider.dart';

class DashboardListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final habitsProvider = Provider.of<HabitsProvider>(context, listen: true);
    final todayHabits = habitsProvider.todayHabits;

    // If no habits are set for today (empty list)
    if (todayHabits.isEmpty) {
      return Center(child: Text('No habits for today'));
    }

    // Filter habits to show only the ones not yet completed
    final filteredHabits = habitsProvider.filteredAndSortedHabits;

    // If all habits are completed, show a congratulatory card
    if (filteredHabits.isEmpty) {
      return Center(
        child: Card(
          color: Colors.orange,
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 48.0),
                SizedBox(height: 8.0),
                Text(
                  'Congrats!',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'All tasks are completed for today.',
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Else, show the filtered habit list
    return _buildHabitList(filteredHabits);
  }

  Widget _buildHabitList(List<TimeInvestmentHabitViewModel> habits) {
    return ListView.builder(
      itemCount: habits.length,
      itemBuilder: (context, index) {
        final habit = habits[index];

        return DashboardListItemView(
          habit: habit,
        );
      },
    );
  }
}
