// models/question.dart

class Question {
  final String id;
  final String text;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
  return Question(
    id: json['_id'] ?? '',
    text: json['text'] ?? '',
    options: (json['options'] as List?)?.map((e) => e.toString()).toList() ?? [],
    correctAnswer: json['correctAnswer'] ?? '',
  );
}

}