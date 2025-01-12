import 'package:flutter/material.dart';
import 'package:habitlyy/habits/services/habits_service.dart';
import 'package:habitlyy/service_locator.dart';
import '../viewmodels/habit_viewmodel.dart';
import 'habit_view.dart';
import 'package:habitlyy/habits/enums/goal_priority.dart';

/// A stateful widget that displays a list of habits.
class HabitsView extends StatefulWidget {
  const HabitsView({super.key});

  @override
  _HabitsViewState createState() => _HabitsViewState();
}

class _HabitsViewState extends State<HabitsView> {
  final habitsService = getIt<IHabitsService>();
  GoalPriority? _selectedPriority;
  bool _filterCompleted = false;
  bool _filterOverdue = false;

  void _addHabit() {
    final titleController = TextEditingController();
    final targetHoursController = TextEditingController();
    final startDateController = TextEditingController();
    final deadlineController = TextEditingController();
    GoalPriority priority = GoalPriority.LOW;

    _showAddHabitDialog(
      titleController,
      targetHoursController,
      startDateController,
      deadlineController,
      priority,
    );
  }

  void _showAddHabitDialog(
    TextEditingController titleController,
    TextEditingController targetHoursController,
    TextEditingController startDateController,
    TextEditingController deadlineController,
    GoalPriority priority,
  ) {
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
                controller: targetHoursController,
                decoration: InputDecoration(labelText: 'Target Hours'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: startDateController,
                decoration: InputDecoration(labelText: 'Start Date'),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      startDateController.text =
                          pickedDate.toLocal().toString().split(' ')[0];
                    });
                  }
                },
              ),
              TextField(
                controller: deadlineController,
                decoration: InputDecoration(labelText: 'Deadline'),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      deadlineController.text =
                          pickedDate.toLocal().toString().split(' ')[0];
                    });
                  }
                },
              ),
              DropdownButton<GoalPriority>(
                value: priority,
                onChanged: (GoalPriority? newValue) {
                  setState(() {
                    priority = newValue!;
                  });
                },
                items: GoalPriority.values.map((GoalPriority classType) {
                  return DropdownMenuItem<GoalPriority>(
                    value: classType,
                    child: Text(classType.toString().split('.').last),
                  );
                }).toList(),
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
                final newHabit = TimeInvestmentHabitViewModel(
                  id: DateTime.now().millisecondsSinceEpoch,
                  title: titleController.text,
                  priority: priority,
                  startDate: DateTime.parse(startDateController.text),
                  deadline: DateTime.parse(deadlineController.text),
                  targetHours: double.parse(targetHoursController.text),
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

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter by Priority'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DropdownButton<GoalPriority>(
                value: _selectedPriority,
                onChanged: (GoalPriority? newValue) {
                  setState(() {
                    _selectedPriority = newValue;
                  });
                },
                items: GoalPriority.values.map((GoalPriority classType) {
                  return DropdownMenuItem<GoalPriority>(
                    value: classType,
                    child: Text(classType.toString().split('.').last),
                  );
                }).toList(),
              ),
              CheckboxListTile(
                title: Text('Completed'),
                value: _filterCompleted,
                onChanged: (bool? value) {
                  setState(() {
                    _filterCompleted = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Overdue'),
                value: _filterOverdue,
                onChanged: (bool? value) {
                  setState(() {
                    _filterOverdue = value!;
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Clear'),
              onPressed: () {
                setState(() {
                  _selectedPriority = null;
                  _filterCompleted = false;
                  _filterOverdue = false;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredHabits = habitsService.getHabits().where((habit) {
      if (_selectedPriority != null && habit.priority != _selectedPriority) {
        return false;
      }
      if (_filterCompleted && !habit.isCompleted()) {
        return false;
      }
      if (_filterOverdue && !habit.isOverdue()) {
        return false;
      }
      return true;
    }).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: ListView.builder(
          itemCount: filteredHabits.length,
          itemBuilder: (context, index) {
            final habit = filteredHabits[index];
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
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: _showFilterDialog,
              child: Icon(Icons.filter_list),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 70.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: _addHabit,
                child: Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
