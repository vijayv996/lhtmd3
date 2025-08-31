enum HabitType {
  yesNo, measurable
}

class Habit {
  final int userId;
  final int habitId;
  final String habitName;
  final DateTime createdOn;
  final HabitType habitType;
  final String? measurementUnit;

  const Habit({
    required this.userId,
    required this.habitId,
    required this.habitName,
    required this.createdOn,
    required this.habitType,
    this.measurementUnit,
  });

  Map<String, Object?> toMap() {
    return {
      'user_id': userId,
      'habit_id': habitId,
      'habit_name': habitName,
      'created_on': createdOn.toIso8601String(),
      'habit_type': habitType.name,
      'measurement_unit': measurementUnit,
    };
  }

  @override
  String toString() {
    return 'Habit(userId: $userId, habitId: $habitId, habitName: $habitName, createdOn: $createdOn, habitType: $habitType, measurementUnit: $measurementUnit)';
  }
}