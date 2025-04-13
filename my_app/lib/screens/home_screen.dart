import 'package:flutter/material.dart';
import '../models/category.dart';
import '../widgets/category_card.dart';
import '../screens/category_detail_screen.dart';
import '../screens/history_screen.dart';

class HomeScreen extends StatelessWidget {
  final String username;

  HomeScreen({required this.username});

  final List<Category> categories = [
    Category(
      id: 'web-dev',
      title: 'Web Development',
      description: 'Tests covering various web development topics and technologies',
      testsAvailable: true,
    ),
    Category(
      id: 'prog-langs',
      title: 'Programming Languages',
      description: 'Tests covering various programming languages and paradigms',
      testsAvailable: true,
    ),
    Category(
      id: 'cs-fundamentals',
      title: 'CS Fundamentals',
      description: 'Tests covering fundamental computer science concepts',
      testsAvailable: true,
    ),
    Category(
      id: 'aptitude',
      title: 'Aptitude',
      description: 'Tests covering various aptitude and reasoning skills',
      testsAvailable: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pariksha',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Text(
                        'Challenge your knowledge!',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.nightlight_round, color: Colors.white),
                        onPressed: () {
                          // Toggle dark/light mode
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.logout, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Welcome, $username',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Select a category to start a quiz or review your previous attempts.',
                style: Theme.of(context).textTheme.	bodyLarge,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                      child: Text('Categories'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HistoryScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                      ),
                      child: Text('History'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return CategoryCard(
                      category: categories[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryDetailScreen(
                              category: categories[index],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  'Developed by Atharva Yadav [T23-101], Pratik Vishe [T23-100], Simran Yewle [T23-102] as a part of the course project for "MAD Lab"',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}