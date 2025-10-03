class PomoEntry {
  final int? sessionId;
  final DateTime startTime;
  final DateTime endTime;
  final int duration;

  PomoEntry({
    this.sessionId,
    required this.startTime,
    required this.endTime,
    required this.duration,
  });

  Map<String, Object?> toMap() {
    return {
      'session_id': sessionId,
      'start_time': startTime.millisecondsSinceEpoch,
      'end_time': endTime.millisecondsSinceEpoch,
      'duration': duration,
    };
  }
}