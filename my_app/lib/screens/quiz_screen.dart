import 'package:flutter/material.dart';
import 'dart:async';
import '../models/quiz.dart';
import '../models/question.dart';
import '../screens/results_screen.dart';

class QuizScreen extends StatefulWidget {
  final Quiz quiz;

  QuizScreen({required this.quiz});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<Question> questions;
  int currentQuestionIndex = 0;
  Map<int, String?> userAnswers = {};
  late Timer _timer;
  int _timeLeft = 0;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _timeLeft = widget.quiz.durationMinutes * 60;
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _submitQuiz();
        }
      });
    });
  }

  void _loadQuestions() {
    // In a real app, you would load questions from API or database
    // For demo purposes, hardcoding some sample questions for HTML Basics
    if (widget.quiz.id == 'html-basics') {
      questions = [
        Question(
          id: 'q1',
          text: 'What does HTML stand for?',
          options: [
            'Hyper Text Markup Language',
            'Hyper Transfer Markup Language',
            'High Text Machine Language',
            'Hyperlink Text Management Language',
          ],
          correctAnswer: 'Hyper Text Markup Language',
        ),
        Question(
          id: 'q2',
          text: 'Which tag is used to create a hyperlink in HTML?',
          options: ['<a>', '<h>', '<p>', '<link>'],
          correctAnswer: '<a>',
        ),
        // Add more questions here
        Question(
          id: 'q3',
          text: 'Which HTML element is used to define the document title?',
          options: ['<head>', '<title>', '<header>', '<meta>'],
          correctAnswer: '<title>',
        ),
        Question(
          id: 'q4',
          text: 'What is the correct HTML for creating a checkbox?',
          options: [
            '<input type="checkbox">',
            '<check>',
            '<checkbox>',
            '<input type="check">'
          ],
          correctAnswer: '<input type="checkbox">',
        ),
        Question(
          id: 'q5',
          text: 'Which HTML attribute specifies an alternate text for an image?',
          options: ['alt', 'title', 'src', 'desc'],
          correctAnswer: 'alt',
        ),
        Question(
          id: 'q6',
          text: 'What is the correct HTML for making a dropdown list?',
          options: [
            '<select>',
            '<input type="dropdown">',
            '<list>',
            '<dropdown>'
          ],
          correctAnswer: '<select>',
        ),
        Question(
          id: 'q7',
          text: 'Which HTML element defines the largest heading?',
          options: ['<h1>', '<h6>', '<heading>', '<head>'],
          correctAnswer: '<h1>',
        ),
        Question(
          id: 'q8',
          text: 'What is the correct HTML for inserting an image?',
          options: [
            '<img src="image.jpg" alt="MyImage">',
            '<image src="image.jpg" alt="MyImage">',
            '<img href="image.jpg" alt="MyImage">',
            '<picture src="image.jpg" alt="MyImage">'
          ],
          correctAnswer: '<img src="image.jpg" alt="MyImage">',
        ),
        Question(
          id: 'q9',
          text: 'Which character is used to indicate an end tag?',
          options: ['/', '!', '*', '^'],
          correctAnswer: '/',
        ),
        Question(
          id: 'q10',
          text: 'Which HTML element is used to define an unordered list?',
          options: ['<ul>', '<ol>', '<li>', '<list>'],
          correctAnswer: '<ul>',
        ),
      ];
    } else {
      // Default placeholder questions for other quizzes
      questions = List.generate(
        10,
        (index) => Question(
          id: 'q${index + 1}',
          text: 'Sample question ${index + 1} for ${widget.quiz.title}',
          options: [
            'Option A',
            'Option B',
            'Option C',
            'Option D',
          ],
          correctAnswer: 'Option A',
        ),
      );
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _submitQuiz() {
    _timer.cancel();
    
    // Calculate score
    int score = 0;
    userAnswers.forEach((questionIndex, answer) {
      if (answer == questions[questionIndex].correctAnswer) {
        score++;
      }
    });
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(
          quiz: widget.quiz,
          score: score,
          questions: questions,
          userAnswers: userAnswers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Question currentQuestion = questions[currentQuestionIndex];
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(  // Added SingleChildScrollView here
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.quiz.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.timer, color: Colors.deepPurple, size: 18),
                          SizedBox(width: 5),
                          Text(
                            _formatTime(_timeLeft),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Question ${currentQuestionIndex + 1} of ${questions.length}',
                  style: TextStyle(color: Colors.grey[400]),
                ),
                SizedBox(height: 5),
                LinearProgressIndicator(
                  value: (currentQuestionIndex + 1) / questions.length,
                  backgroundColor: Colors.grey[800],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentQuestion.text,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      ...currentQuestion.options.map((option) {
                        bool isSelected = userAnswers[currentQuestionIndex] == option;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              userAnswers[currentQuestionIndex] = option;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 12),
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.deepPurple.withOpacity(0.2) : Colors.black,
                              border: Border.all(
                                color: isSelected ? Colors.deepPurple : Colors.grey[800]!,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? Colors.deepPurple : Colors.grey[600]!,
                                      width: 2,
                                    ),
                                    color: isSelected ? Colors.deepPurple : Colors.transparent,
                                  ),
                                  child: isSelected
                                      ? Icon(
                                          Icons.check,
                                          size: 12,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                SizedBox(height: 30),  // Changed from Spacer() to SizedBox for fixed spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: currentQuestionIndex > 0
                          ? () {
                              setState(() {
                                currentQuestionIndex--;
                              });
                            }
                          : null,
                      icon: Icon(
                        Icons.arrow_back,
                        color: currentQuestionIndex > 0 ? Colors.grey : Colors.grey[700],
                      ),
                      label: Text(
                        'Previous',
                        style: TextStyle(
                          color: currentQuestionIndex > 0 ? Colors.grey : Colors.grey[700],
                        ),
                      ),
                    ),
                    currentQuestionIndex < questions.length - 1
                        ? TextButton.icon(
                            onPressed: () {
                              setState(() {
                                currentQuestionIndex++;
                              });
                            },
                            icon: Text(
                              'Next',
                              style: TextStyle(color: Colors.deepPurple),
                            ),
                            label: Icon(Icons.arrow_forward, color: Colors.deepPurple),
                          )
                        : TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.grey[900],
                                    title: Text(
                                      'Finish Test',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    content: Text(
                                      'Are you sure you want to submit your answers?',
                                      style: TextStyle(color: Colors.grey[300]),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          _submitQuiz();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.deepPurple,
                                        ),
                                        child: Text('Submit'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text(
                              'Finish Test',
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Answered: ${userAnswers.length} of ${questions.length}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    bool isAnswered = userAnswers.containsKey(index);
                    bool isCurrent = index == currentQuestionIndex;
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          currentQuestionIndex = index;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? Colors.deepPurple
                              : isAnswered
                                  ? Colors.deepPurple.withOpacity(0.3)
                                  : Colors.grey[900],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: isCurrent || isAnswered ? Colors.white : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),  // Added extra padding at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}