import 'package:flutter/material.dart';
import '../models/quiz.dart';
import '../models/question.dart';
import '../screens/home_screen.dart';

class ResultsScreen extends StatelessWidget {
  final Quiz quiz;
  final int score;
  final List<Question> questions;
  final Map<int, String?> userAnswers;

  ResultsScreen({
    required this.quiz,
    required this.score,
    required this.questions,
    required this.userAnswers,
  });

  bool get isPassed => score >= quiz.passingMarks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Test Results',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      quiz.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Web Development',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isPassed
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: isPassed
                              ? Colors.green.withOpacity(0.2)
                              : Colors.red.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isPassed ? Colors.green : Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isPassed ? Icons.check : Icons.close,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      isPassed ? 'Passed' : 'Failed',
                      style: TextStyle(
                        color: isPassed ? Colors.green : Colors.red,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '$score/${quiz.questionCount}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Passing marks: ${quiz.passingMarks}',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    SizedBox(height: 20),
                    LinearProgressIndicator(
                      value: score / quiz.questionCount,
                      backgroundColor: Colors.grey[800],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isPassed ? Colors.green : Colors.red,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildResultStat(
                          context: context,
                          icon: Icons.military_tech,
                          label: 'Score',
                          value: '$score out of ${quiz.questionCount}',
                          color: Colors.deepPurple,
                        ),
                        _buildResultStat(
                          context: context,
                          icon: Icons.equalizer,
                          label: 'Accuracy',
                          value: '${(score / quiz.questionCount * 100).toStringAsFixed(0)}%',
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildTab(context, 'All Questions', true),
                        SizedBox(width: 10),
                        _buildTab(context, 'Correct (${score})', false),
                        SizedBox(width: 10),
                        _buildTab(context, 'Incorrect (${quiz.questionCount - score})', false),
                      ],
                    ),
                    SizedBox(height: 20),
                    ...List.generate(questions.length, (index) {
                      bool isCorrect = userAnswers[index] == questions[index].correctAnswer;
                      return _buildQuestionResult(
                        context: context,
                        questionNumber: index + 1,
                        question: questions[index],
                        userAnswer: userAnswers[index],
                        isCorrect: isCorrect,
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(
                              username: 'Diksha yelave', // Replace with actual user
                            ),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text('Back to Home'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Restart the quiz
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.deepPurple,
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text('Retake Quiz'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, String text, bool isActive) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.deepPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultStat({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionResult({
    required BuildContext context,
    required int questionNumber,
    required Question question,
    required String? userAnswer,
    required bool isCorrect,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: userAnswer == null
              ? Colors.grey[800]!
              : isCorrect
                  ? Colors.green
                  : Colors.red,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: userAnswer == null
                      ? Colors.grey[800]
                      : isCorrect
                          ? Colors.green
                          : Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$questionNumber',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  question.text,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(
                userAnswer == null
                    ? Icons.help_outline
                    : isCorrect
                        ? Icons.check_circle_outline
                        : Icons.cancel_outlined,
                color: userAnswer == null
                    ? Colors.grey
                    : isCorrect
                        ? Colors.green
                        : Colors.red,
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Correct answer:',
            style: TextStyle(
              color: Colors.green,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 4),
          Text(
            question.correctAnswer,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (userAnswer != null && !isCorrect) ...[
            SizedBox(height: 10),
            Text(
              'Your answer:',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 4),
            Text(
              userAnswer,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
