import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quiz_session.dart';

class QuizService {
  static const String baseUrl = 'http://localhost:5173/api';

  static Future<QuizSession> joinQuiz(String pin, String studentId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/quiz/join'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'PIN': pin,
          'SID': studentId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return QuizSession.fromJson(data);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Failed to join quiz');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<QuizSession> getQuizStatus(String testID) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/test/$testID'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return QuizSession.fromJson(data);
      } else {
        throw Exception('Failed to get quiz status');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<bool> submitAnswer({
    required String testID,
    required String studentId,
    required int questionIndex,
    required String answer,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/quiz/answer'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'testID': testID,
          'SID': studentId,
          'questionIndex': questionIndex,
          'selectedAnswer': answer,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error submitting answer: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> checkAnswer({
    required String testID,
    required String studentId,
    required int questionIndex,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/quiz/checkAnswer'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'testID': testID,
          'SID': studentId,
          'questionIndex': questionIndex,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'correct': false, 'error': true};
      }
    } catch (e) {
      return {'correct': false, 'error': true};
    }
  }
}
