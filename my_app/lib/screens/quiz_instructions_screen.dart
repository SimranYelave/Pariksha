import 'package:flutter/material.dart';
import '../models/quiz.dart';
import '../screens/quiz_screen.dart';

class QuizInstructionsScreen extends StatelessWidget {
  final Quiz quiz;

  QuizInstructionsScreen({required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.deepPurple),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          quiz.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // This makes the instructions part scrollable while keeping the button at the bottom
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
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
                        Text(
                          'Web Development',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        SizedBox(height: 16),
                        Text(
                          quiz.description,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 20),
                        Divider(color: Colors.grey[800]),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(Icons.description, color: Colors.deepPurple),
                            SizedBox(width: 10),
                            Text(
                              'Questions',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Text(
                              '${quiz.questionCount} questions',
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(Icons.timer, color: Colors.deepPurple),
                            SizedBox(width: 10),
                            Text(
                              'Duration',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Text(
                              '${quiz.durationMinutes} minutes',
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(Icons.military_tech, color: Colors.deepPurple),
                            SizedBox(width: 10),
                            Text(
                              'Total Marks',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Text(
                              '${quiz.questionCount} marks',
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(Icons.military_tech, color: Colors.deepPurple),
                            SizedBox(width: 10),
                            Text(
                              'Passing Marks',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Text(
                              '${quiz.passingMarks} marks',
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                          ],
                        ),
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
                          'The test will automatically submit when the time is up.',
                        ),
                        SizedBox(height: 8),
                        _buildInstructionItem(
                          'You can navigate between questions using the next and previous buttons.',
                        ),
                        SizedBox(height: 8),
                        _buildInstructionItem(
                          'You can review your answers before final submission.',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Button stays at bottom but outside scroll area
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
                  child: Text(
                    'Start Quiz',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('• ', style: TextStyle(color: Colors.amber, fontSize: 18)),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}