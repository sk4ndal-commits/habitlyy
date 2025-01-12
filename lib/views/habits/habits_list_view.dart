import 'package:flutter/material.dart';
import 'package:habitlyy/service_locator.dart';
import '../../enums/frequency_days.dart';
import '../../enums/habit_priority.dart';
import '../../services/habits/ihabits_service.dart';
import '../../viewmodels/habits/habit_viewmodel.dart';
import 'habit_view.dart';

/// A stateful widget that displays a list of habits.
class HabitsView extends StatefulWidget {
  const HabitsView({super.key});

  @override
  _HabitsViewState createState() => _HabitsViewState();
}

class _HabitsViewState extends State<HabitsView> {
  final habitsService = getIt<IHabitsService>();
  HabitPriority? _selectedPriority;
  bool _filterCompleted = false;
  bool _filterOverdue = false;
  final _formKey = GlobalKey<FormState>();

  void _addHabit() {
    final titleController = TextEditingController();
    final targetHoursController = TextEditingController();
    final startDateController = TextEditingController();
    final deadlineController = TextEditingController();
    HabitPriority priority = HabitPriority.LOW;

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
    HabitPriority priority,
  ) {
    List<FrequencyDay> selectedFrequencyDays = [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Habit'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextFormField(
                  controller: targetHoursController,
                  decoration: InputDecoration(labelText: 'Target Hours'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value';
                    }
                    final number = double.tryParse(value);
                    if (number == null || number <= 0) {
                      return 'Please enter a number greater than 0';
                    }
                    return null;
                  },
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
                Row(
                  children: [
                    Text('Priority'),
                    SizedBox(width: 8.0),
                    DropdownButton<HabitPriority>(
                      value: priority,
                      onChanged: (HabitPriority? newValue) {
                        setState(() {
                          priority = newValue!;
                        });
                      },
                      items:
                          HabitPriority.values.map((HabitPriority classType) {
                        return DropdownMenuItem<HabitPriority>(
                          value: classType,
                          child: Text(classType.toString().split('.').last),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Frequency Days'),
                    ),
                    SizedBox(width: 8.0),
                    Wrap(
                      spacing: 8.0,
                      children: FrequencyDay.values.map((day) {
                        return ChoiceChip(
                          label: Text(
                              day.toString().split('.').last.substring(0, 2)),
                          selected: selectedFrequencyDays.contains(day),
                          onSelected: (bool selected) {
                            setState(() {
                              selected
                                  ? selectedFrequencyDays.add(day)
                                  : selectedFrequencyDays.remove(day);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
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
              child: Text('Add'),
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newHabit = TimeInvestmentHabitViewModel(
                    id: DateTime.now().millisecondsSinceEpoch,
                    title: titleController.text,
                    priority: priority,
                    startDate: DateTime.parse(startDateController.text),
                    deadline: DateTime.parse(deadlineController.text),
                    targetHours: double.parse(targetHoursController.text),
                    frequencyDays: selectedFrequencyDays,
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
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showFilterDialog() {
    HabitPriority? tempSelectedPriority = _selectedPriority;
    bool tempFilterCompleted = _filterCompleted;
    bool tempFilterOverdue = _filterOverdue;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter by Priority'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DropdownButton<HabitPriority>(
                value: tempSelectedPriority,
                onChanged: (HabitPriority? newValue) {
                  setState(() {
                    tempSelectedPriority = newValue;
                  });
                },
                items: HabitPriority.values.map((HabitPriority classType) {
                  return DropdownMenuItem<HabitPriority>(
                    value: classType,
                    child: Text(classType.toString().split('.').last),
                  );
                }).toList(),
              ),
              CheckboxListTile(
                title: Text('Completed'),
                value: tempFilterCompleted,
                onChanged: (bool? value) {
                  setState(() {
                    tempFilterCompleted = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Overdue'),
                value: tempFilterOverdue,
                onChanged: (bool? value) {
                  setState(() {
                    tempFilterOverdue = value!;
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Clear'),
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              onPressed: () {
                setState(() {
                  _selectedPriority = null;
                  _filterCompleted = false;
                  _filterOverdue = false;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Apply'),
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              onPressed: () {
                setState(() {
                  _selectedPriority = tempSelectedPriority;
                  _filterCompleted = tempFilterCompleted;
                  _filterOverdue = tempFilterOverdue;
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
              backgroundColor: Colors.orange,
              child: Icon(Icons.filter_list),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 70.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                backgroundColor: Colors.orange,
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
