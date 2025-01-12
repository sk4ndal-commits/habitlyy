import 'package:flutter/material.dart';
import 'package:habitlyy/service_locator.dart';
import 'package:habitlyy/views/dashboard/dashboard_list_item_view.dart';
import '../../services/habits/ihabits_service.dart';

class DashboardListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final habitsService = getIt<IHabitsService>();
    final todayHabits = habitsService.getTodayHabits();

    return Expanded(
      child: ListView.builder(
        itemCount: todayHabits.length,
        itemBuilder: (context, index) {
          final habit = todayHabits[index];
          return DashboardListItemView(habit: habit);
        },
      ),
    );
  }
}
