import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/quiz.dart';
import '../services/quiz_service.dart';
import '../services/test_service.dart';
import '../screens/quiz_instructions_screen.dart';

class CategoryDetailScreen extends StatefulWidget {
  final Category category;

  CategoryDetailScreen({required this.category});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  final QuizService quizService = QuizService();
  late Future<List<Quiz>> quizzesFuture;

  @override
  void initState() {
    super.initState();
    quizzesFuture = quizService.fetchTestsByCategory(widget.category.id);
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
          widget.category.title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.category.description, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Quiz>>(
                future: quizzesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No quizzes found'));
                  }

                  final quizzes = snapshot.data!;
                  for (var quiz in quizzes) {
                    print("Quiz Loaded: ${quiz.id} - ${quiz.title}");
                  }

                  return ListView.builder(
                    itemCount: quizzes.length,
                    itemBuilder: (context, index) => _buildQuizCard(context, quizzes[index]),
                  );
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
      onTap: () async {
        try {
          final fetchedQuiz = await TestService().fetchTestById(quiz.id);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizInstructionsScreen(testId: quiz.id),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load test: $e')),
          );
        }
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
                  decoration: BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle),
                ),
                SizedBox(width: 10),
                Text(
                  quiz.title,
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(quiz.description, style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoBox(context, Icons.description, '${quiz.questionCount} Questions'),
                _buildInfoBox(context, Icons.military_tech,
                    '${quiz.passingMarks}/${quiz.questionCount} to Pass'),
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
      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 20),
          SizedBox(height: 5),
          Text(text, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        ],
      ),
    );
  }
}
