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
  late HabitPriority _selectedPriority;

  @override
  void initState() {
    super.initState();
    _selectedPriority = widget.habit.priority;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: _buildTitle(),
        subtitle: _buildSubtitle(),
        trailing: _buildTrailingButtons(),
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.habit.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
        ),
        _buildPriorityChip(),
        SizedBox(width: 8.0),
        _buildFrequencyDaysChip(),
      ],
    );
  }

  Widget _buildPriorityChip() {
    return Container(
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
    );
  }

  Widget _buildFrequencyDaysChip() {
    return Container(
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
    );
  }

  Widget _buildSubtitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDateRow(Icons.calendar_month, widget.habit.startDate),
        _buildDateRow(Icons.calendar_month_outlined, widget.habit.deadline),
        _buildTargetHoursRow(),
      ],
    );
  }

  Widget _buildDateRow(IconData icon, DateTime date) {
    return Row(
      children: [
        Icon(icon, size: 16.0, color: Colors.grey),
        SizedBox(width: 4.0),
        Text('${date.toLocal().toString().split(' ')[0]}'),
      ],
    );
  }

  Widget _buildTargetHoursRow() {
    return Row(
      children: [
        Icon(Icons.access_time, size: 16.0, color: Colors.grey),
        SizedBox(width: 4.0),
        Text('${widget.habit.targetHours}h'),
      ],
    );
  }

  Widget _buildTrailingButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildEditButton(context),
        _buildDeleteButton(context),
      ],
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
    List<FrequencyDay> selectedFrequencyDays = [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${widget.habit.title}'),
          content: _buildEditDialogContent(
            startDateController,
            deadlineController,
            targetHoursController,
            selectedFrequencyDays,
          ),
          actions: _buildEditDialogActions(
            context,
            startDateController,
            deadlineController,
            targetHoursController,
            selectedFrequencyDays,
          ),
        );
      },
    );
  }

  Widget _buildEditDialogContent(
    TextEditingController startDateController,
    TextEditingController deadlineController,
    TextEditingController targetHoursController,
    List<FrequencyDay> selectedFrequencyDays,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.0),
        _buildPriorityDropdown(),
        SizedBox(height: 8.0),
        _buildDatePickerField('Start Date', startDateController),
        SizedBox(height: 8.0),
        _buildDatePickerField('Deadline', deadlineController),
        SizedBox(height: 8.0),
        _buildTextField('Target Hours', targetHoursController),
        SizedBox(height: 8.0),
        _buildFrequencyDaysChips(selectedFrequencyDays),
      ],
    );
  }

  Widget _buildPriorityDropdown() {
    return Row(
      children: [
        Text("Priority"),
        SizedBox(width: 8.0),
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return DropdownButton<HabitPriority>(
              value: _selectedPriority,
              onChanged: (HabitPriority? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedPriority = newValue;
                  });
                }
              },
              items: HabitPriority.values.map((HabitPriority priority) {
                return DropdownMenuItem<HabitPriority>(
                  value: priority,
                  child: Text(priority.toString().split('.').last),
                );
              }).toList(),
            );
          },
        ),
      ],
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
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
                  label: Text(day.toString().split('.').last.substring(0, 2)),
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

  List<Widget> _buildEditDialogActions(
    BuildContext context,
    TextEditingController startDateController,
    TextEditingController deadlineController,
    TextEditingController targetHoursController,
    List<FrequencyDay> selectedFrequencyDays,
  ) {
    return [
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
            widget.habit.priority = _selectedPriority;
            widget.habit.startDate = DateTime.parse(startDateController.text);
            widget.habit.deadline = DateTime.parse(deadlineController.text);
            widget.habit.targetHours = double.parse(targetHoursController.text);
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
    ];
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
