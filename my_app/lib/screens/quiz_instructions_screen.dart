import 'package:flutter/material.dart';
import '../models/quiz.dart';
import '../screens/quiz_screen.dart';
import '../services/test_service.dart';

class QuizInstructionsScreen extends StatefulWidget {
  final String testId;

  const QuizInstructionsScreen({required this.testId, Key? key}) : super(key: key);

  @override
  State<QuizInstructionsScreen> createState() => _QuizInstructionsScreenState();
}

class _QuizInstructionsScreenState extends State<QuizInstructionsScreen> {
  late Future<Quiz> _quizFuture;

  @override
  void initState() {
    super.initState();
    _quizFuture = TestService().fetchTestById(widget.testId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.deepPurple),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Quiz Instructions',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<Quiz>(
        future: _quizFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData) {
            return Center(child: Text('Quiz not found'));
          }

          final quiz = snapshot.data!;

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Test Instructions',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            quiz.description,
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 20),
                          Divider(color: Colors.grey[800]),
                          SizedBox(height: 20),
                          _buildRow('Questions', '${quiz.questionCount} questions'),
                          _buildRow('Duration', '${quiz.durationMinutes} minutes'),
                          _buildRow('Total Marks', '${quiz.totalMarks} marks'),
                          _buildRow('Passing Marks', '${quiz.passingMarks} marks'),
                          SizedBox(height: 30),
                          Text(
                            'Important Instructions:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          _buildInstructionItem(
                              'The test will automatically submit when the time is up.'),
                          SizedBox(height: 8),
                          _buildInstructionItem(
                              'You can navigate between questions using the next and previous buttons.'),
                          SizedBox(height: 8),
                          _buildInstructionItem(
                              'You can review your answers before final submission.'),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizScreen(quiz: quiz),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text('Start Quiz', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      children: [
        Icon(Icons.info_outline, color: Colors.deepPurple),
        SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Spacer(),
        Text(value, style: TextStyle(color: Colors.grey[400])),
      ],
    );
  }

  Widget _buildInstructionItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('• ', style: TextStyle(color: Colors.amber, fontSize: 18)),
        Expanded(child: Text(text, style: TextStyle(color: Colors.white))),
      ],
    );
  }
}
