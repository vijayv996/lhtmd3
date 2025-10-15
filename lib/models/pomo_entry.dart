class PomoEntry {
  final int? sessionId;
  final DateTime startTime;
  final DateTime endTime;
  final int duration;
  final String focusName;
  final int? habitId;

  PomoEntry({
    this.sessionId,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.focusName,
    this.habitId,
  });

  Map<String, Object?> toMap() {
    return {
      'session_id': sessionId,
      'start_time': startTime.millisecondsSinceEpoch,
      'end_time': endTime.millisecondsSinceEpoch,
      'duration': duration,
      'focus_name': focusName,
      'habit_id': habitId,
    };
  }
}