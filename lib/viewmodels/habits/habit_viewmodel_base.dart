// Base class: Goal
import 'package:habitlyy/enums/frequency_days.dart';

import '../../enums/habit_priority.dart';

class HabitViewModelBase {
  int id;
  String title;
  HabitPriority priority;
  late bool completed;
  late DateTime lastUpdated;
  List<FrequencyDay>? frequencyDays;
  final int userId;

  HabitViewModelBase({
    required this.id,
    required this.title,
    required this.priority,
    required this.frequencyDays,
    required this.userId,
  }) {
    completed = false;
    lastUpdated = DateTime.now();
  }

  @override
  String toString() {
    return '$title - $priority';
  }

  bool isCompleted() {
    return completed;
  }

  void complete() {
    completed = true;
  }
}