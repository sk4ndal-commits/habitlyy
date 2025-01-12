import 'package:flutter/material.dart';
import 'package:habitlyy/viewmodels/habits/habit_viewmodel.dart';

class DashboardListItemView extends StatelessWidget {
  final TimeInvestmentHabitViewModel habit;

  DashboardListItemView({required this.habit});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      color: Colors.black12,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  habit.title,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Handle update action
                  },
                  icon: Icon(Icons.update, color: Colors.orange),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            LinearProgressIndicator(
              value: habit.investedHours / habit.targetHours,
              backgroundColor: Colors.grey[300],
              color: Colors.green,
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${habit.investedHours} / ${habit.targetHours} hours',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}