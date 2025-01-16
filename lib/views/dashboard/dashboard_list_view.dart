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
  @override
  Widget build(BuildContext context) {
    final habitsService = getIt<IHabitsService>();
    final todayHabits = habitsService.getTodayHabits();
    final filteredHabits = _filterAndSortHabits(todayHabits);

    return _buildHabitList(filteredHabits);
  }

  List<TimeInvestmentHabitViewModel> _filterAndSortHabits(
      List<TimeInvestmentHabitViewModel> habits) {
    final filteredHabits = habits
        .where((habit) => habit.investedHours < habit.targetHours)
        .toList();
    filteredHabits.sort((a, b) => a.priority.index.compareTo(b.priority.index));
    return filteredHabits;
  }

  Widget _buildHabitList(List<TimeInvestmentHabitViewModel> habits) {
    return Expanded(
      child: ListView.builder(
        itemCount: habits.length,
        itemBuilder: (context, index) {
          final habit = habits[index];
          return DashboardListItemView(
            habit: habit,
            onHabitUpdated: () {
              setState(() {});
            },
          );
        },
      ),
    );
  }
}
