class HabitEntry {
  final int entryId;
  final int habitId;
  final DateTime entryDate;
  final double value;

  const HabitEntry({
    required this.entryId,
    required this.habitId,
    required this.entryDate,
    required this.value,
  });

  Map<String, Object?> toMap() {
    return {
      'entry_id': entryId,
      'habit_id': habitId,
      'entry_date': entryDate.toIso8601String(),
      'value': value,
    };
  }

  @override
  String toString() {
    return 'HabitEntry(entryId: $entryId, habitId: $habitId, entryDate: $entryDate, value: $value)';
  }
}