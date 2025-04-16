// Base class: Goal
import 'package:habitlyy/enums/frequency_days.dart';

import '../../enums/habit_priority.dart';

/// Base class for all habit view models
abstract class HabitViewModelBase {
  int id;
  String title;
  HabitPriority priority;
  late DateTime lastUpdated;
  List<FrequencyDay>? frequencyDays;

  HabitViewModelBase({
    required this.id,
    required this.title,
    required this.priority,
    required this.frequencyDays,
  }) {
    lastUpdated = DateTime.now();
  }

  @override
  String toString() {
    return '$title - $priority';
  }

  /// Check if the habit is completed
  /// This method should be implemented by derived classes
  bool isCompleted();

  /// Calculate the completion percentage
  /// This method should be implemented by derived classes
  double calculateCompletionPercentage();
}
