class Quiz {
  final String id;
  final String title;
  final String description;
  final int questionCount;
  final int passingMarks;
  final int durationMinutes;
  final int totalMarks; // ✅ New field

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.questionCount,
    required this.passingMarks,
    required this.durationMinutes,
    required this.totalMarks, // ✅ Add to constructor
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      questionCount: json['totalQuestions'],
      passingMarks: json['passingMarks'],
      durationMinutes: json['duration'],
      totalMarks: json['totalMarks'], // ✅ Extract from JSON
    );
  }
}
