import 'package:flutter/material.dart';
import 'package:habitlyy/providers/habit_provider.dart';
import 'package:habitlyy/service_locator.dart';
import 'package:provider/provider.dart';

import '../../enums/frequency_days.dart';
import '../../enums/habit_priority.dart';
import '../../services/habits/ihabits_service.dart';
import '../../services/profile/iuser_service.dart';
import '../../viewmodels/habits/habit_viewmodel.dart';
import 'habit_view.dart';

/// A stateful widget that displays a list of habits.
class HabitListView extends StatefulWidget {
  const HabitListView({super.key});

  @override
  _HabitListViewState createState() => _HabitListViewState();
}

class _HabitListViewState extends State<HabitListView> {
  final habitsService = getIt<IHabitsService>();
  final userService = getIt<IUserService>();
  List<TimeInvestmentHabitViewModel> _localHabits = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchHabits(); // Fetch habits when the widget is built
  }

  void _fetchHabits() async {
    final currentUser = await userService.getCurrentUserAsync();
    if (currentUser != null) {
      final habits = await habitsService.getHabitsByUserIdAsync(currentUser.id);
      setState(() {
        _localHabits = habits; 
      });
    }
  }

  void _addHabit(HabitsProvider habitsProvider) {
    final titleController = TextEditingController();
    final targetHoursController = TextEditingController();
    HabitPriority priority = HabitPriority.LOW;

    _showAddHabitDialog(
      titleController,
      targetHoursController,
      priority,
      habitsProvider,
    );
  }

  void _showAddHabitDialog(
    TextEditingController titleController,
    TextEditingController targetHoursController,
    HabitPriority initialPriority,
    HabitsProvider habitsProvider,
  ) {
    List<FrequencyDay> selectedFrequencyDays = [];
    HabitPriority currentPriority =
        initialPriority; // Maintain the updated priority

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Add Habit'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _buildTextField(titleController, "Title"),
                    _buildTextFormField(
                        targetHoursController, "Target Hours (in numbers)"),
                    _buildPriorityDropdown(currentPriority, (newPriority) {
                      setState(() {
                        currentPriority =
                            newPriority; // Update local priority state
                      });
                    }),
                    _buildFrequencyDaysChips(selectedFrequencyDays, setState),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  child: Text('Add'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final newHabit = TimeInvestmentHabitViewModel(
                        id: DateTime.now().millisecondsSinceEpoch,
                        title: titleController.text,
                        priority: currentPriority,
                        // Use the updated priority
                        targetHours: double.parse(targetHoursController.text),
                        frequencyDays: selectedFrequencyDays,
                        userId: await userService.getCurrentUserAsync()!.id,
                      );

                      try {
                        await habitsProvider.addHabitAsync(newHabit);
                        setState(() {
                          _localHabits.add(newHabit);
                        });
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${newHabit.title} added'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error adding habit: $e'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
    );
  }

  Widget _buildTextFormField(
    TextEditingController controller,
    String labelText,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        final parsedValue = double.tryParse(value);
        if (parsedValue == null || parsedValue <= 0) {
          return 'Please enter a valid number greater than 0';
        }
        return null;
      },
    );
  }

  Future<void> _deleteHabit(int habitId, HabitsProvider habitsProvider) async {
    try {
      await habitsProvider.deleteHabitAsync(habitId);
      setState(() {
        _localHabits.removeWhere(
            (habit) => habit.id == habitId); // Remove habit from local list
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Habit deleted'),
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting habit: $e'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Widget _buildPriorityDropdown(HabitPriority currentPriority,
      Function(HabitPriority) onPriorityChanged) {
    return Row(
      children: [
        Text('Priority'),
        SizedBox(width: 8.0),
        DropdownButton<HabitPriority>(
          value: currentPriority, // Use the passed currentPriority from state
          onChanged: (HabitPriority? newValue) {
            if (newValue != null) {
              onPriorityChanged(newValue); // Notify parent about the change
            }
          },
          items: HabitPriority.values.map((HabitPriority priority) {
            return DropdownMenuItem<HabitPriority>(
              value: priority,
              child: Text(priority.toString().split('.').last),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFrequencyDaysChips(
      List<FrequencyDay> selectedFrequencyDays, StateSetter dialogSetState) {
    return Column(
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
              label: Text(day.toString().split('.').last.substring(0, 2)),
              selected: selectedFrequencyDays.contains(day),
              onSelected: (bool selected) {
                dialogSetState(() {
                  selected
                      ? selectedFrequencyDays.add(day)
                      : selectedFrequencyDays.remove(day);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final habitsProvider = Provider.of<HabitsProvider>(context);

    return Scaffold(
      body: _localHabits.isEmpty
          ? Center(child: Text("No habits found"))
          : ListView.builder(
              itemCount: _localHabits.length,
              itemBuilder: (context, index) {
                final habit = _localHabits[index];
                return HabitView(
                  habit: habit,
                  onDelete: () => _deleteHabit(habit.id, habitsProvider),
                  habitsProvider: habitsProvider,
                );
              },
            ),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () => _addHabit(habitsProvider),
              backgroundColor: Colors.orange,
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
