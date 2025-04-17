import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../features/home/data/models/contest_model.dart';
import '../../features/home/data/models/contestant_model.dart';
import '../../features/home/data/models/performance_model.dart';
import 'api_service.dart';

class RemoteApiService implements ApiService {
  final http.Client _client;
  final String _baseUrl;

  RemoteApiService(
      {http.Client? client,
      String baseUrl = 'https://api.eurovision.example.com'})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl;

  @override
  Future<List<int>> getContestYears() async {
    final response = await _client.get(Uri.parse('$_baseUrl/contests/years'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return List<int>.from(data);
    } else {
      throw Exception('Failed to load contest years');
    }
  }

  @override
  Future<ContestModel> getContestByYear(int year) async {
    final response = await _client.get(Uri.parse('$_baseUrl/contests/$year'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ContestModel.fromJson(data);
    } else {
      throw Exception('Failed to load contest for year $year');
    }
  }

  @override
  Future<List<ContestantModel>> getContestantsByYear(int year) async {
    final response =
        await _client.get(Uri.parse('$_baseUrl/contests/$year/contestants'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ContestantModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load contestants for year $year');
    }
  }

  @override
  Future<List<PerformanceModel>> getVotingResultsByYear(int year) async {
    final response =
        await _client.get(Uri.parse('$_baseUrl/contests/$year/results'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => PerformanceModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load voting results for year $year');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getFeaturedContent() async {
    final response = await _client.get(Uri.parse('$_baseUrl/featured'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load featured content');
    }
  }

  @override
  Future<List<ContestModel>> searchContests(String query) async {
    final response = await _client
        .get(Uri.parse('$_baseUrl/search?q=${Uri.encodeComponent(query)}'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ContestModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search contests');
    }
  }
}
