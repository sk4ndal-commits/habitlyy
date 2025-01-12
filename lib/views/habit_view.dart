import 'package:flutter/material.dart';

import '../enums/goal_priority.dart';
import '../viewmodels/habit_viewmodel.dart';

/// A widget that displays a habit with options to edit or delete it.
class HabitView extends StatelessWidget {
  final TimeInvestmentHabitViewModel habit;
  final VoidCallback onDelete;

  const HabitView({
    Key? key,
    required this.habit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Row(
          children: [
            Expanded(
              child: Text(
                habit.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                habit.priority.toString().split('.').last,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_month, size: 16.0, color: Colors.grey),
                SizedBox(width: 4.0),
                Text('${habit.startDate.toLocal().toString().split(' ')[0]}'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.calendar_month_outlined, size: 16.0, color: Colors.grey),
                SizedBox(width: 4.0),
                Text('${habit.deadline.toLocal().toString().split(' ')[0]}'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.access_time, size: 16.0, color: Colors.grey),
                SizedBox(width: 4.0),
                Text('${habit.targetHours}h'),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEditButton(context),
            _buildDeleteButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.edit, color: Colors.grey),
      onPressed: () {
        _showEditDialog(context);
      },
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.grey),
      onPressed: () {
        _showDeleteDialog(context);
      },
    );
  }

  void _showEditDialog(BuildContext context) {
    TextEditingController startDateController = TextEditingController(
        text: habit.startDate.toLocal().toString().split(' ')[0]);
    TextEditingController deadlineController = TextEditingController(
        text: habit.deadline.toLocal().toString().split(' ')[0]);
    TextEditingController targetHoursController =
        TextEditingController(text: habit.targetHours.toString());
    GoalPriority selectedPriority = habit.priority;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${habit.title}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.0),
              Text("Priority"),
              DropdownButton<GoalPriority>(
                value: selectedPriority,
                onChanged: (GoalPriority? newValue) {
                  if (newValue != null) {
                    selectedPriority = newValue;
                  }
                },
                items: GoalPriority.values.map((GoalPriority priority) {
                  return DropdownMenuItem<GoalPriority>(
                    value: priority,
                    child: Text(priority.toString().split('.').last),
                  );
                }).toList(),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: startDateController,
                decoration: InputDecoration(labelText: 'Start Date'),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: deadlineController,
                decoration: InputDecoration(labelText: 'Deadline'),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: targetHoursController,
                decoration: InputDecoration(labelText: 'Target Hours'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              onPressed: () {
                // Update the habit details
                habit.priority = selectedPriority;
                habit.startDate = DateTime.parse(startDateController.text);
                habit.deadline = DateTime.parse(deadlineController.text);
                habit.targetHours = double.parse(targetHoursController.text);

                // Close the dialog
                Navigator.of(context).pop();

                // Show SnackBar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Changes saved'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(habit.title),
          content: Text('Do you really want to delete this habit?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              onPressed: () {
                onDelete();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${habit.title} deleted'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
