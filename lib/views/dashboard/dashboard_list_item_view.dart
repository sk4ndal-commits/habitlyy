import 'package:flutter/material.dart';
import 'package:habitlyy/viewmodels/habits/habit_viewmodel.dart';

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.habit.title,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
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
                IconButton(
                  onPressed: () {
                    _showUpdateInvestedHoursDialog(context, widget.habit);
                  },
                  icon: Icon(Icons.update, color: Colors.orange),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            LinearProgressIndicator(
              value: widget.habit.investedHours / widget.habit.targetHours,
              backgroundColor: Colors.grey[300],
              color: Colors.green,
            ),
            SizedBox(height: 8.0),
            Row(
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
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateInvestedHoursDialog(
      BuildContext context, TimeInvestmentHabitViewModel habit) {
    final investedHoursController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Invested Hours'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: investedHoursController,
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
              child: Text('Save'),
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newInvestedHours =
                      double.tryParse(investedHoursController.text);
                  if (newInvestedHours != null) {
                    setState(() {
                      habit.investedHours += newInvestedHours;
                    });
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
          ],
        );
      },
    );
  }
}