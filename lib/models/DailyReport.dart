class DailyReport {
  final int id;
  final int dailyTaskId;
  final int reportId;
  final int sessionId;
  final String score;

  DailyReport({
    required this.id,
    required this.dailyTaskId,
    required this.reportId,
    required this.sessionId,
    required this.score,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'daily_task_id': dailyTaskId,
      'report_id': reportId,
      'sesion_id': sessionId,
      'score': score,
    };
  }
}
