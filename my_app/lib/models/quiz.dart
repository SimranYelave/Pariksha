class Quiz {
  final String id;
  final String title;
  final String description;
  final int questionCount;
  final int passingMarks;
  final int durationMinutes;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.questionCount,
    required this.passingMarks,
    required this.durationMinutes,
  });
}