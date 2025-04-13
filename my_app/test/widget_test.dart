import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pariksha_quiz_app/screens/home_screen.dart';

import 'package:pariksha_quiz_app/screens/results_screen.dart';
import 'package:pariksha_quiz_app/screens/history_screen.dart';
import 'package:pariksha_quiz_app/models/category.dart';
import 'package:pariksha_quiz_app/models/quiz.dart';
import 'package:pariksha_quiz_app/models/question.dart';
import 'package:pariksha_quiz_app/widgets/category_card.dart';

void main() {
  testWidgets('App should render title in AppBar', (WidgetTester tester) async {
    // Build the app and trigger a frame
    await tester.pumpWidget(MaterialApp(
      home: HomeScreen(username: 'Test User'),
    ));

    // Verify the app title is displayed
    expect(find.text('Pariksha'), findsOneWidget);
  });

  testWidgets('HomeScreen should display username correctly', (WidgetTester tester) async {
    const testUsername = 'Diksha Yelave';
    
    await tester.pumpWidget(MaterialApp(
      home: HomeScreen(username: testUsername),
    ));

    // Verify that username appears in the UI
    expect(find.text('Welcome, $testUsername'), findsOneWidget);
  });

  testWidgets('CategoryCard should display category details correctly', (WidgetTester tester) async {
    // Create a test category
    final testCategory = Category(
      id: '1',
      title: 'Web Development',
      description: 'Learn HTML, CSS, and JavaScript',
      testsAvailable: true,
    );
    
    bool wasPressed = false;
    
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CategoryCard(
          category: testCategory,
          onTap: () {
            wasPressed = true;
          },
        ),
      ),
    ));

    // Verify category details appear correctly
    expect(find.text('Web Development'), findsOneWidget);
    expect(find.text('Learn HTML, CSS, and JavaScript'), findsOneWidget);
    expect(find.text('Multiple tests available'), findsOneWidget);
    
    // Test the tap functionality
    await tester.tap(find.byType(GestureDetector));
    expect(wasPressed, true);
  });

  testWidgets('Quiz model should calculate passing marks correctly', (WidgetTester tester) async {
    final testQuiz = Quiz(
      id: '1',
      title: 'HTML Basics',
      description: 'Test your knowledge of HTML fundamentals',
      questionCount: 10,
      passingMarks: 6,
      durationMinutes: 15,
    );
    
    // Verify quiz properties
    expect(testQuiz.title, 'HTML Basics');
    expect(testQuiz.questionCount, 10);
    expect(testQuiz.passingMarks, 6);
  });

  testWidgets('Results screen should show correct/incorrect status', (WidgetTester tester) async {
    // Create test quiz and questions
    final testQuiz = Quiz(
      id: '1',
      title: 'HTML Basics',
      description: 'Test your HTML knowledge',
      questionCount: 2,
      passingMarks: 2,
      durationMinutes: 10,
    );
    
    final testQuestions = [
      Question(
        id: '1',
        text: 'What does HTML stand for?',
        options: ['Hyper Text Markup Language', 'High Tech Modern Language', 'Hyper Transfer Markup Language', 'None of the above'],
        correctAnswer: 'Hyper Text Markup Language',
      ),
      Question(
        id: '2',
        text: 'Which tag is used for a line break?',
        options: ['<lb>', '<break>', '<br>', '<newline>'],
        correctAnswer: '<br>',
      ),
    ];
    
    // User got first question right, second question wrong
    final userAnswers = {
      0: 'Hyper Text Markup Language',
      1: '<lb>',
    };
    
    await tester.pumpWidget(MaterialApp(
      home: ResultsScreen(
        quiz: testQuiz,
        score: 1,  // One correct answer
        questions: testQuestions,
        userAnswers: userAnswers,
      ),
    ));
    
    // Verify the results screen shows failed since score (1) < passingMarks (2)
    expect(find.text('Failed'), findsOneWidget);
    expect(find.text('1/2'), findsOneWidget);
    
    // Verify correct answer info is displayed
    expect(find.text('Correct answer:'), findsNWidgets(2));
    expect(find.text('Your answer:'), findsOneWidget); // Only for the incorrect answer
  });

  testWidgets('HistoryScreen should display test history', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: HistoryScreen(),
    ));
    
    // Verify the history screen title
    expect(find.text('Your History'), findsOneWidget);
    
    // Verify the history item is displayed (based on hardcoded data)
    expect(find.text('HTML Basics'), findsOneWidget);
    expect(find.text('Score: 3/10'), findsOneWidget);
  });

  testWidgets('Question renders options correctly', (WidgetTester tester) async {
    // Create a test question
    final testQuestion = Question(
      id: '1',
      text: 'What is Flutter?',
      options: [
        'A bird',
        'A UI framework',
        'A database',
        'A programming language'
      ],
      correctAnswer: 'A UI framework',
    );
    
    // Build a simple widget to display the question options
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Text(testQuestion.text),
            ...testQuestion.options.map((option) => Text(option)).toList(),
          ],
        ),
      ),
    ));
    
    // Verify that the question text and all options are displayed
    expect(find.text('What is Flutter?'), findsOneWidget);
    expect(find.text('A bird'), findsOneWidget);
    expect(find.text('A UI framework'), findsOneWidget);
    expect(find.text('A database'), findsOneWidget);
    expect(find.text('A programming language'), findsOneWidget);
  });

  testWidgets('Quiz navigation buttons work correctly', (WidgetTester tester) async {
    // Create test questions
    final testQuestions = [
      Question(
        id: '1',
        text: 'Question 1',
        options: ['A', 'B', 'C', 'D'],
        correctAnswer: 'A',
      ),
      Question(
        id: '2',
        text: 'Question 2',
        options: ['W', 'X', 'Y', 'Z'],
        correctAnswer: 'Z',
      ),
    ];
    
    // Create a simple QuizScreen-like widget that just tests navigation
    await tester.pumpWidget(MaterialApp(
      home: StatefulBuilder(
        builder: (context, setState) {
          int currentIndex = 0;
          return Scaffold(
            body: Column(
              children: [
                Text('Question ${currentIndex + 1}'),
                Text(testQuestions[currentIndex].text),
                Row(
                  children: [
                    TextButton(
                      onPressed: currentIndex > 0 
                        ? () => setState(() => currentIndex--) 
                        : null,
                      child: Text('Previous'),
                    ),
                    TextButton(
                      onPressed: currentIndex < testQuestions.length - 1 
                        ? () => setState(() => currentIndex++) 
                        : null,
                      child: Text('Next'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    ));
    
    // Initially we should see Question 1
    expect(find.text('Question 1'), findsOneWidget);
    expect(find.text('Question 1'), findsOneWidget);
    
    // Previous button should be disabled (null onPressed)
    final prevButton = find.text('Previous');
    expect(tester.widget<TextButton>(prevButton).onPressed, null);
    
    // Click Next
    await tester.tap(find.text('Next'));
    await tester.pump();
    
    // Now we should see Question 2
    expect(find.text('Question 2'), findsOneWidget);
    expect(find.text('Question 2'), findsOneWidget);
    
    // Previous button should now be enabled
    expect(tester.widget<TextButton>(prevButton).onPressed, isNotNull);
  });

  testWidgets('App handles empty state gracefully', (WidgetTester tester) async {
    // Test that app handles edge cases like empty username
    await tester.pumpWidget(MaterialApp(
      home: HomeScreen(username: ''),
    ));
    
    // Even with empty username, app should render without errors
    expect(find.text('Welcome,'), findsOneWidget);
  });
}