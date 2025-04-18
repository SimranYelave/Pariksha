import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quiz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizService {
  final String baseUrl = 'https://madpwa-backend.onrender.com/api/categories';

  // quiz_service.dart or test_service.dart
Future<List<Quiz>> fetchTestsByCategory(String categoryId) async {
  final response = await http.get(Uri.parse('$baseUrl/$categoryId/tests'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Quiz.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load tests');
  }
}

}
