import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'https://madpwa-backend.onrender.com/api';

  // Get token from local storage
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Get cookie from local storage
  Future<String?> getCookie() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('cookie');
  }

  // Get user data from local storage
  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');
    if (userDataString == null) return null;
    return jsonDecode(userDataString);
  }

  // Check login status
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  // Login function
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final cookie = response.headers['set-cookie'];
        await _storeUserData(responseData['token'], responseData['user'], cookie);
        return {'success': true, 'data': responseData};
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection error. Please check your internet connection.',
      };
    }
  }

  // Register function
  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        final cookie = response.headers['set-cookie'];
        await _storeUserData(responseData['token'], responseData['user'], cookie);
        return {'success': true, 'data': responseData};
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection error. Please check your internet connection.',
      };
    }
  }

  // Fetch current user using stored token or cookie
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final token = await getToken();
      final cookie = await getCookie();

      if (token == null && cookie == null) {
        return {'success': false, 'message': 'No token or cookie found'};
      }

      final response = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
          if (cookie != null) 'Cookie': cookie,
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', jsonEncode(responseData));
        return {'success': true, 'data': responseData};
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to get user data',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection error. Please check your internet connection.',
      };
    }
  }

  // Logout function - clears stored token, user data, and cookie
  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
    await prefs.remove('cookie');
    return true;
  }

  // Store token, user data, and cookie
  Future<void> _storeUserData(
      String token, Map<String, dynamic> userData, String? cookie) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_data', jsonEncode(userData));
    if (cookie != null) {
      await prefs.setString('cookie', cookie);
    }
  }

  // Return an authorized HTTP client (Bearer + Cookie)
  Future<http.Client> getAuthClient() async {
    final client = http.Client();
    final token = await getToken();
    final cookie = await getCookie();
    if (token != null || cookie != null) {
      return AuthenticatedClient(client, token, cookie);
    }
    return client;
  }
}

// Custom authenticated client to auto-include Bearer token and Cookie
class AuthenticatedClient extends http.BaseClient {
  final http.Client _inner;
  final String? _token;
  final String? _cookie;

  AuthenticatedClient(this._inner, this._token, this._cookie);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    if (_token != null) {
      request.headers['Authorization'] = 'Bearer $_token';
    }
    if (_cookie != null) {
      request.headers['Cookie'] = _cookie!;
    }
    return _inner.send(request);
  }
}
