import 'package:flutter/material.dart';
import 'package:habitlyy/habits/services/habits_service.dart';
import 'package:habitlyy/habits/viewmodels/habit_viewmodel.dart';
import 'package:habitlyy/service_locator.dart';
import 'habit_view.dart';

/// A stateful widget that displays a list of habits.
class HabitsView extends StatefulWidget {
  const HabitsView({super.key});

  @override
  _HabitsViewState createState() => _HabitsViewState();
}

class _HabitsViewState extends State<HabitsView> {
  final habitsService = getIt<IHabitsService>();

  void _addHabit() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    _showAddHabitDialog(titleController, descriptionController);
  }

  void _showAddHabitDialog(TextEditingController titleController,
      TextEditingController descriptionController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Habit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                final newHabit = HabitViewModel(
                  id: DateTime.now().millisecondsSinceEpoch,
                  title: titleController.text,
                  description: descriptionController.text,
                  startDate: DateTime.now(),
                );
                setState(() {
                  habitsService.addHabit(newHabit);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${newHabit.title} added'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        // Add padding to the bottom
        child: ListView.builder(
          itemCount: habitsService.getHabits().length,
          itemBuilder: (context, index) {
            final habit = habitsService.getHabits()[index];
            return HabitView(
              habit: habit,
              onDelete: () {
                setState(() {
                  habitsService.removeHabit(habit.id);
                });
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addHabit,
        child: Icon(Icons.add),
      ),
    );
  }
}
