import 'package:flutter/material.dart';
import 'package:habitlyy/habits/viewmodels/habit_viewmodel.dart';

class HabitView extends StatelessWidget {
  final HabitViewModel habit;
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
        title: Text(
          habit.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        subtitle: Text(habit.description),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.grey),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Confirm Deletion'),
                  content: Text('Do you really want to delete this habit?'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Yes'),
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
          },
        ),
      ),
    );
  }
}