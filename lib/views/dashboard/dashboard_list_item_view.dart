import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habitlyy/viewmodels/habits/habit_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../providers/habit_provider.dart';

class DashboardListItemView extends StatefulWidget {
  final TimeInvestmentHabitViewModel habit;

  DashboardListItemView({required this.habit});

  @override
  _DashboardListItemViewState createState() => _DashboardListItemViewState();
}

class _DashboardListItemViewState extends State<DashboardListItemView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 8.0),
            _buildProgressIndicator(),
            SizedBox(height: 8.0),
            _buildHoursText(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.habit.title,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        _buildPriorityChip(),
        IconButton(
          onPressed: () {
            _showUpdateInvestedHoursDialog(context, widget.habit);
          },
          icon: Icon(Icons.update, color: Colors.orange),
        ),
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

  Widget _buildProgressIndicator() {
    return LinearProgressIndicator(
      value: widget.habit.investedHours / widget.habit.targetHours,
      backgroundColor: Colors.grey[300],
      color: Colors.green,
    );
  }

  Widget _buildHoursText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${widget.habit.investedHours} / ${widget.habit.targetHours} hours',
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  void _showUpdateInvestedHoursDialog(
      BuildContext context, TimeInvestmentHabitViewModel habit) {
    final investedHoursController = TextEditingController();
    Timer? timer;
    int seconds = 0;

    void startTimer(StateSetter updateState) {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        updateState(() {
          seconds++;
        });
      });
    }

    void stopTimer() {
      timer?.cancel();
      final hours = seconds / 3600;
      investedHoursController.text = hours.toStringAsFixed(4);
    }

    String formatTime(int seconds) {
      final int hours = seconds ~/ 3600;
      final int minutes = (seconds % 3600) ~/ 60;
      final int remainingSeconds = seconds % 60;
      return '$hours:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Update Invested Hours'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTimerButtons(setState, startTimer, stopTimer),
                    SizedBox(height: 4.0),
                    Text('Timer: ${formatTime(seconds)}'),
                    SizedBox(height: 16.0),
                    _buildInvestedHoursField(investedHoursController),
                  ],
                ),
              ),
              actions: _buildDialogActions(
                  context, investedHoursController, stopTimer),
            );
          },
        );
      },
    );
  }

  Widget _buildTimerButtons(StateSetter setState,
      void Function(StateSetter) startTimer, void Function() stopTimer) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () => startTimer(setState),
          child: Text('Start Timer'),
        ),
        ElevatedButton(
          onPressed: stopTimer,
          child: Text('Stop Timer'),
        ),
      ],
    );
  }

  Widget _buildInvestedHoursField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: 'Invested Hours'),
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
    );
  }

  List<Widget> _buildDialogActions(BuildContext context,
      TextEditingController controller, void Function() stopTimer) {
    return [
      ElevatedButton(
        child: Text('Cancel'),
        onPressed: () {
          stopTimer();
          Navigator.of(context).pop();
        },
      ),
      ElevatedButton(
        child: Text('Save'),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final newInvestedHours = double.tryParse(controller.text);
            if (newInvestedHours != null) {
              await Provider.of<HabitsProvider>(context, listen: false)
                  .updateInvestedHoursAsync(widget.habit, newInvestedHours);
              setState(() {});
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Invested hours updated'),
                  duration: Duration(seconds: 1),
                ),
              );
            }
          }
        },
      ),
    ];
  }
}
