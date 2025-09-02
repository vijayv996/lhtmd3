enum HabitType {
  yesNo, measurable
}

class Habit {
  final int userId;
  final int habitId;
  final String habitName;
  final HabitType habitType;
  final String? measurementUnit;

  const Habit({
    required this.userId,
    required this.habitId,
    required this.habitName,
    required this.habitType,
    this.measurementUnit,
  });

  Map<String, Object?> toMap() {
    return {
      'user_id': userId,
      'habit_id': habitId,
      'habit_name': habitName,
      'habit_type': habitType.name,
      'measurement_unit': measurementUnit,
    };
  }

  @override
  String toString() {
    return 'Habit(userId: $userId, habitId: $habitId, habitName: $habitName, habitType: $habitType, measurementUnit: $measurementUnit)';
  }
}