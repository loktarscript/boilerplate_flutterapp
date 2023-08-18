class DailyTask {
  final int id;
  final int taskId;
  final String dayTask;
  final String fechaFinalizacion;
  final String horaFinalizacion;
  final bool isCompleted;

  DailyTask({
    required this.id,
    required this.taskId,
    required this.dayTask,
    required this.fechaFinalizacion,
    required this.horaFinalizacion,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task_id': taskId,
      'day_task': dayTask,
      'fecha_finalizacion': fechaFinalizacion,
      'hora_finalizacion': horaFinalizacion,
      'is_completed': isCompleted ? 1 : 0,
    };
  }
}
