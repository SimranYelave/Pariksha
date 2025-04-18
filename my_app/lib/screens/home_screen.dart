import 'package:flutter/material.dart';
import '../models/category.dart';
import '../widgets/category_card.dart';
import '../screens/category_detail_screen.dart';
import '../screens/history_screen.dart';
import '../services/category_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final String username;
  final CategoryService categoryService = CategoryService();

  HomeScreen({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
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
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.nightlight_round, color: Colors.white),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.logout, color: Colors.white),
                        onPressed: () {
                          // Navigate to login page
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()), // Replace with your login page
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Welcome message
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
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              SizedBox(height: 20),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
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
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800]),
                      child: Text('History'),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Fetch and show categories
              Expanded(
                child: FutureBuilder<List<Category>>(
                  future: categoryService.fetchCategories(), // API call here
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No categories found'));
                    }

                    final categories = snapshot.data!;
                    return ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return CategoryCard(
                          category: categories[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryDetailScreen(category: categories[index]),
                              ),
                            );
                          },
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
