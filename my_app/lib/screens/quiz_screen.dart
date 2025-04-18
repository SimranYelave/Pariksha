import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/quiz.dart';
import '../models/question.dart';
import '../screens/results_screen.dart';
import 'dart:math';
class QuizScreen extends StatefulWidget {
  final Quiz quiz;

  QuizScreen({required this.quiz});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<Question> questions = [];
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

  Future<void> _loadQuestions() async {
    try {
      
      final response = await http.get(
        Uri.parse('https://madpwa-backend.onrender.com/api/tests/${widget.quiz.id}/questions'),
      );

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
       

        List<dynamic> questionList = [];

        // Directly access 'questions' from the response body
        if (jsonBody.containsKey('questions') && jsonBody['questions'] is List) {
          questionList = jsonBody['questions'];
        }

        setState(() {
          questions = questionList
              .map<Question>((json) => Question.fromJson(json))
              .toList();

          if (questions.isEmpty) {
            questions = [
              Question(
                id: '1',
                text: 'Sample question - API data could not be loaded',
                options: ['Option A', 'Option B', 'Option C', 'Option D'],
                correctAnswer: 'Option A',
              ),
            ];
          }
        });
      } else {
        throw Exception('Failed to load questions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading questions: $e');
      setState(() {
        questions = [
          Question(
            id: '0',
            text: 'Could not load questions. Please check your internet connection.',
            options: ['Retry', 'Go back', 'Contact support'],
            correctAnswer: 'Retry',
          ),
        ];
      });
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

void _submitQuiz() async {
  _timer.cancel();

  int totalQuestions = questions.length;
  int score = 0;
  int timeTaken = widget.quiz.durationMinutes * 60 - _timeLeft;

  // Generate a MongoDB-like ObjectId for the submission
  String generateObjectId() {
    final timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toRadixString(16).padLeft(8, '0');
    final machineId = (Random().nextInt(16777216)).toRadixString(16).padLeft(6, '0');
    final processId = (Random().nextInt(65536)).toRadixString(16).padLeft(4, '0');
    final counter = (Random().nextInt(16777216)).toRadixString(16).padLeft(6, '0');
    return timestamp + machineId + processId + counter;
  }

  List<Map<String, dynamic>> answerList = [];

  userAnswers.forEach((index, selectedText) {
    if (index < questions.length && selectedText != null) {
      final question = questions[index];
      int selectedOption = question.options.indexOf(selectedText);
      bool isCorrect = selectedText == question.correctAnswer;
      
      if (isCorrect) score++;
      
      answerList.add({
        '_id': generateObjectId(), // Add ID to each answer
        'questionId': question.id,
        'selectedOption': selectedOption,
        'isCorrect': isCorrect,
      });
    }
  });

  bool passed = score >= (0.4 * totalQuestions);

  final submissionData = {
    '_id': generateObjectId(), // Add ID to the overall submission
    'user': '67c5d5ddc62a4410f7017b43', // Use the correct user ID from your example
    'testId': widget.quiz.id,
    'score': score,
    'passed': passed,
    'timeTaken': timeTaken,
    'answers': answerList,
    'completedAt': DateTime.now().toIso8601String(),
  };

  try {
    // Log the submission data for debugging
    print("Submitting data: ${json.encode(submissionData)}");
    
    final response = await http.post(
      Uri.parse('https://madpwa-backend.onrender.com/api/tests/${widget.quiz.id}/submit'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(submissionData),
    );

    if (response.statusCode == 200) {
      print("Quiz submitted successfully.");
    } else {
      print("Failed to submit quiz: ${response.statusCode}");
      print("Response body: ${response.body}");
    }
  } catch (e) {
    print("Error submitting quiz: $e");
  }

  // Navigate to Results Screen
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
    if (questions.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    Question currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.timer,
                              color: Colors.deepPurple, size: 18),
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
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.deepPurple),
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
                        bool isSelected =
                            userAnswers[currentQuestionIndex] == option;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              userAnswers[currentQuestionIndex] = option;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 12),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.deepPurple.withOpacity(0.2)
                                  : Colors.black,
                              border: Border.all(
                                color: isSelected
                                    ? Colors.deepPurple
                                    : Colors.grey[800]!,
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
                                      color: isSelected
                                          ? Colors.deepPurple
                                          : Colors.grey[600]!,
                                      width: 2,
                                    ),
                                    color: isSelected
                                        ? Colors.deepPurple
                                        : Colors.transparent,
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
                SizedBox(height: 30),
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
                        color: currentQuestionIndex > 0
                            ? Colors.grey
                            : Colors.grey[700],
                      ),
                      label: Text(
                        'Previous',
                        style: TextStyle(
                          color: currentQuestionIndex > 0
                              ? Colors.grey
                              : Colors.grey[700],
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
                            label:
                                Icon(Icons.arrow_forward, color: Colors.deepPurple),
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
                              color:
                                  isCurrent || isAnswered ? Colors.white : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
