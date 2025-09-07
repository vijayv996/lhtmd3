import 'package:lhtmd3/models/habit.dart';
import 'package:lhtmd3/models/habit_entry.dart';

class HabitWithEntries {
  final Habit habit;
  final List<HabitEntry> entries;

  const HabitWithEntries({
    required this.habit,
    required this.entries,
  });
}