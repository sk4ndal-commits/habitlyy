import 'package:flutter/material.dart';
import 'package:habitlyy/service_locator.dart';
import 'package:habitlyy/views/dashboard/dashboard_list_item_view.dart';
import '../../services/habits/ihabits_service.dart';

class DashboardListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final habitsService = getIt<IHabitsService>();
    final todayHabits = habitsService.getTodayHabits();
    final filteredHabits = todayHabits
        .where((habit) => habit.investedHours < habit.targetHours)
        .toList();
    filteredHabits.sort((a, b) => a.priority.index.compareTo(b.priority.index));

    return Expanded(
      child: ListView.builder(
        itemCount: filteredHabits.length,
        itemBuilder: (context, index) {
          final habit = filteredHabits[index];
          return DashboardListItemView(habit: habit);
        },
      ),
    );
  }
}
