// Base class: Goal
import '../enums/goal_priority.dart';

class HabitViewModelBase {
  int id;
  String title;
  GoalPriority priority;
  late bool completed;
  DateTime startDate;
  DateTime deadline;
  late DateTime lastUpdated;

  HabitViewModelBase({
    required this.id,
    required this.title,
    required this.priority,
    required this.startDate,
    required this.deadline,
  }) {
    completed = false;
    lastUpdated = DateTime.now();
  }

  @override
  String toString() {
    return '$title - $priority';
  }

  int daysLeft() {
    return deadline.difference(DateTime.now()).inDays;
  }

  bool isCompleted() {
    return completed;
  }

  void complete() {
    completed = true;
  }
}