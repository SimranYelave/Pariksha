// services/test_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quiz.dart';

class TestService {
  final String baseUrl = 'https://madpwa-backend.onrender.com/api';

  Future<Quiz> fetchTestById(String testId) async {
   
    
    final response = await http.get(Uri.parse('$baseUrl/tests/$testId'));
    
    if (response.statusCode == 200) {
      // Parse the JSON response
      final dynamic data = jsonDecode(response.body);
      return Quiz.fromJson(data);
    } else {
      throw Exception('Failed to load test details: ${response.statusCode}');
    }
  }
}