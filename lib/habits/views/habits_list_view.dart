import 'package:flutter/material.dart';
import 'package:habitlyy/habits/services/habits_service.dart';
import 'package:habitlyy/service_locator.dart';

class HabitsView extends StatefulWidget {
  const HabitsView({super.key});

  @override
  _HabitsViewState createState() => _HabitsViewState();
}

class _HabitsViewState extends State<HabitsView> {
  final habitsService = getIt<IHabitsService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: habitsService
            .getHabits()
            .length,
        itemBuilder: (context, index) {
          final habit = habitsService.getHabits()[index];
          return ListTile(
            title: Text(habit.title),
            subtitle: Text(habit.description),
            trailing: IconButton(
              icon: Icon(Icons.delete),
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
                            setState(() {
                              habitsService.removeHabit(habit.id);
                            });
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Habit deleted'),
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
          );
        },
      ),
    );
  }
}