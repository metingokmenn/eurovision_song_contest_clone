import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:eurovision_song_contest_clone/core/constants/constant_index.dart';

class ApiClient {
  final http.Client _httpClient;

  ApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  /// Base method for making GET requests
  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('${Consts.baseUrl}$endpoint');

    try {
      final response = await _httpClient.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      return _processResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Base method for making POST requests
  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    final url = Uri.parse('${Consts.baseUrl}$endpoint');

    try {
      final response = await _httpClient.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body != null ? json.encode(body) : null,
      );

      return _processResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Process HTTP response and handle errors
  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else if (response.statusCode == 404) {
      throw Exception('Resource not found');
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }
}
