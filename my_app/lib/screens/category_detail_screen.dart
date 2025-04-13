import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/quiz.dart';
import '../screens/quiz_instructions_screen.dart';

class CategoryDetailScreen extends StatelessWidget {
  final Category category;

  CategoryDetailScreen({required this.category});

  final List<Quiz> webDevQuizzes = [
    Quiz(
      id: 'html-basics',
      title: 'HTML Basics',
      description: 'Test your knowledge of HTML fundamentals',
      questionCount: 10,
      passingMarks: 6,
      durationMinutes: 5,
    ),
    Quiz(
      id: 'css-fundamentals',
      title: 'CSS Fundamentals',
      description: 'Test your knowledge of CSS styling concepts',
      questionCount: 10,
      passingMarks: 6,
      durationMinutes: 5,
    ),
    Quiz(
      id: 'js-basics',
      title: 'JavaScript Basics',
      description: 'Test your knowledge of JavaScript programming',
      questionCount: 10,
      passingMarks: 6,
      durationMinutes: 5,
    ),
    Quiz(
      id: 'react-fundamentals',
      title: 'React Fundamentals',
      description: 'Test your knowledge of React.js framework',
      questionCount: 10,
      passingMarks: 6,
      durationMinutes: 5,
    ),
    Quiz(
      id: 'node-express',
      title: 'Node.js and Express',
      description: 'Test your knowledge of Node.js and Express framework',
      questionCount: 10,
      passingMarks: 6,
      durationMinutes: 5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.deepPurple),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          category.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: webDevQuizzes.length,
                itemBuilder: (context, index) {
                  return _buildQuizCard(context, webDevQuizzes[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizCard(BuildContext context, Quiz quiz) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizInstructionsScreen(quiz: quiz),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
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
                Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  quiz.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              quiz.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoBox(context, Icons.description, '${quiz.questionCount} Questions'),
                _buildInfoBox(context, Icons.military_tech, '${quiz.passingMarks}/${quiz.questionCount} to Pass'),
                _buildInfoBox(context, Icons.timer, '${quiz.durationMinutes} Minutes'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(BuildContext context, IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 20),
          SizedBox(height: 5),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
