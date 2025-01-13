import 'package:flutter/material.dart';

import '../../enums/frequency_days.dart';
import '../../enums/habit_priority.dart';
import '../../viewmodels/habits/habit_viewmodel.dart';

class HabitView extends StatefulWidget {
  final TimeInvestmentHabitViewModel habit;
  final VoidCallback onDelete;

  const HabitView({
    Key? key,
    required this.habit,
    required this.onDelete,
  }) : super(key: key);

  @override
  _HabitViewState createState() => _HabitViewState();
}

class _HabitViewState extends State<HabitView> {
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
                widget.habit.title,
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
                widget.habit.priority.toString().split('.').last,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 8.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                _abbreviateFrequencyDays(widget.habit.frequencyDays),
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
                Text(
                    '${widget.habit.startDate.toLocal().toString().split(' ')[0]}'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.calendar_month_outlined,
                    size: 16.0, color: Colors.grey),
                SizedBox(width: 4.0),
                Text(
                    '${widget.habit.deadline.toLocal().toString().split(' ')[0]}'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.access_time, size: 16.0, color: Colors.grey),
                SizedBox(width: 4.0),
                Text('${widget.habit.targetHours}h'),
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

  String _abbreviateFrequencyDays(List<FrequencyDay>? frequencyDays) {
    if (frequencyDays == null || frequencyDays.isEmpty) {
      return '';
    }
    return frequencyDays.map((day) {
      switch (day) {
        case FrequencyDay.MONDAY:
          return 'MO';
        case FrequencyDay.TUESDAY:
          return 'TU';
        case FrequencyDay.WEDNESDAY:
          return 'WE';
        case FrequencyDay.THURSDAY:
          return 'TH';
        case FrequencyDay.FRIDAY:
          return 'FR';
        case FrequencyDay.SATURDAY:
          return 'SA';
        case FrequencyDay.SUNDAY:
          return 'SU';
      }
    }).join(', ');
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
        text: widget.habit.startDate.toLocal().toString().split(' ')[0]);
    TextEditingController deadlineController = TextEditingController(
        text: widget.habit.deadline.toLocal().toString().split(' ')[0]);
    TextEditingController targetHoursController =
        TextEditingController(text: widget.habit.targetHours.toString());
    HabitPriority selectedPriority = widget.habit.priority;
    List<FrequencyDay> selectedFrequencyDays = [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${widget.habit.title}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.0),
              Row(
                children: [
                  Text("Priority"),
                  SizedBox(width: 8.0),
                  DropdownButton<HabitPriority>(
                    value: selectedPriority,
                    onChanged: (HabitPriority? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedPriority = newValue;
                        });
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
              ),
              SizedBox(height: 8.0),
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
              SizedBox(height: 8.0),
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
              SizedBox(height: 8.0),
              TextField(
                controller: targetHoursController,
                decoration: InputDecoration(labelText: 'Target Hours'),
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
                setState(() {
                  // Update the habit details
                  widget.habit.priority = selectedPriority;
                  widget.habit.startDate =
                      DateTime.parse(startDateController.text);
                  widget.habit.deadline =
                      DateTime.parse(deadlineController.text);
                  widget.habit.targetHours =
                      double.parse(targetHoursController.text);
                  if (selectedFrequencyDays.isNotEmpty) {
                    widget.habit.frequencyDays = selectedFrequencyDays;
                  }
                });

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
          title: Text(widget.habit.title),
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
                widget.onDelete();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${widget.habit.title} deleted'),
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
