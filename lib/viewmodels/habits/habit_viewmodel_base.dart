// Base class: Goal
import 'package:habitlyy/enums/frequency_days.dart';

import '../../enums/habit_priority.dart';

class HabitViewModelBase {
  int id;
  String title;
  HabitPriority priority;
  late bool completed;
  DateTime startDate;
  DateTime deadline;
  late DateTime lastUpdated;
  List<FrequencyDays>? frequencyDays;

  HabitViewModelBase({
    required this.id,
    required this.title,
    required this.priority,
    required this.startDate,
    required this.deadline,
    required this.frequencyDays,
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