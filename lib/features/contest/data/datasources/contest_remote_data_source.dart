import 'package:eurovision_song_contest_clone/features/contest/data/models/contest_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContestRemoteDataSource {
  final String baseUrl = 'https://eurovisionapi.runasp.net/api';
  final http.Client client;

  ContestRemoteDataSource({required this.client});

  Future<List<int>> getContestYears() async {
    final response = await client.get(Uri.parse('$baseUrl/contests/years'));
    if (response.statusCode == 200) {
      final List<dynamic> years = json.decode(response.body);
      return years.cast<int>();
    } else {
      throw Exception('Failed to load contest years');
    }
  }

  Future<ContestModel> getContestByYear(int year) async {
    final response = await client.get(Uri.parse('$baseUrl/contests/$year'));
    if (response.statusCode == 200) {
      return ContestModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load contest for year $year');
    }
  }

  Future<List<int>> getJuniorContestYears() async {
    final response = await client.get(
      Uri.parse('$baseUrl/junior/contests/years'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> years = json.decode(response.body);
      return years.cast<int>();
    } else {
      throw Exception('Failed to load junior contest years');
    }
  }

  Future<ContestModel> getJuniorContestByYear(int year) async {
    final response = await client.get(
      Uri.parse('$baseUrl/junior/contests/$year'),
    );
    if (response.statusCode == 200) {
      return ContestModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load junior contest for year $year');
    }
  }
}
