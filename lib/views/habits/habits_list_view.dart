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
  HabitPriority? _selectedPriority;
  bool _filterCompleted = false;
  bool _filterOverdue = false; // Filters for completed and overdue habits
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
        _localHabits = habits; // Store fetched habits in the local list
      });
    }
  }

  void _addHabit(HabitsProvider habitsProvider) {
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
      habitsProvider,
    );
  }

  void _showAddHabitDialog(TextEditingController titleController,
      TextEditingController targetHoursController,
      TextEditingController startDateController,
      TextEditingController deadlineController,
      HabitPriority priority,
      HabitsProvider habitsProvider,) {
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
                _buildTextField(titleController, "Title"),
                _buildTextFormField(
                    targetHoursController, "Target Hours (in numbers)"),
                _buildDatePickerField("Start Date", startDateController),
                _buildDatePickerField("Deadline", deadlineController),
                _buildPriorityDropdown(priority),
                _buildFrequencyDaysChips(selectedFrequencyDays),
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
                    id: DateTime
                        .now()
                        .millisecondsSinceEpoch,
                    title: titleController.text,
                    priority: priority,
                    startDate: DateTime.parse(startDateController.text),
                    deadline: DateTime.parse(deadlineController.text),
                    targetHours: double.parse(targetHoursController.text),
                    frequencyDays: selectedFrequencyDays,
                    userId: await userService.getCurrentUserAsync()!.id,
                  );

                  try {
                    await habitsProvider.addHabitAsync(newHabit);
                    setState(() {
                      _localHabits
                          .add(newHabit); // Immediately add to local state
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
  }

  void _showFilterDialog() {
    HabitPriority? tempSelectedPriority = _selectedPriority;
    bool tempFilterCompleted = _filterCompleted;
    bool tempFilterOverdue = _filterOverdue;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter Habits'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DropdownButton<HabitPriority>(
                value: tempSelectedPriority,
                hint: Text('Select Priority'),
                onChanged: (HabitPriority? newValue) {
                  setState(() {
                    tempSelectedPriority = newValue;
                  });
                },
                items: HabitPriority.values.map((priority) {
                  return DropdownMenuItem<HabitPriority>(
                    value: priority,
                    child: Text(priority
                        .toString()
                        .split('.')
                        .last),
                  );
                }).toList(),
              ),
              CheckboxListTile(
                title: Text('Completed'),
                value: tempFilterCompleted,
                onChanged: (bool? value) {
                  setState(() {
                    tempFilterCompleted = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Overdue'),
                value: tempFilterOverdue,
                onChanged: (bool? value) {
                  setState(() {
                    tempFilterOverdue = value ?? false;
                  });
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
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
            ElevatedButton(
              child: Text('Apply'),
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

  List<TimeInvestmentHabitViewModel> _applyFilters() {
    return _localHabits.where((habit) {
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
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
    );
  }

  Widget _buildTextFormField(TextEditingController controller,
      String labelText,) {
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

  Widget _buildDatePickerField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
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
            controller.text = pickedDate.toLocal().toString().split(' ')[0];
          });
        }
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

  Widget _buildPriorityDropdown(HabitPriority priority) {
    return Row(
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
          items: HabitPriority.values.map((HabitPriority classType) {
            return DropdownMenuItem<HabitPriority>(
              value: classType,
              child: Text(classType
                  .toString()
                  .split('.')
                  .last),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFrequencyDaysChips(List<FrequencyDay> selectedFrequencyDays) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Frequency Days'),
        ),
        SizedBox(width: 8.0),
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Wrap(
              spacing: 8.0,
              children: FrequencyDay.values.map((day) {
                return ChoiceChip(
                  label: Text(day
                      .toString()
                      .split('.')
                      .last
                      .substring(0, 2)),
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
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final habitsProvider = Provider.of<HabitsProvider>(context);

    final filteredHabits = _applyFilters();

    return Scaffold(
        body: filteredHabits.isEmpty
            ? Center(child: Text("No habits found"))
            : ListView.builder(
          itemCount: filteredHabits.length,
          itemBuilder: (context, index) {
            final habit = filteredHabits[index];
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
                  onPressed: () => _addHabit(habitsProvider),
                  child: Icon(Icons.add),
                ),
              ),
            ),
          ],
        ),
    );
  }
}
