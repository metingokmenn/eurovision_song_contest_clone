import 'package:eurovision_song_contest_clone/features/home/data/models/contest_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../core/constants/constant_index.dart';

class ContestRemoteDataSource {
  final String baseUrl = Consts.baseUrl;
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

  Future<List<dynamic>> getContestantsByYear(int year) async {
    final response = await client.get(Uri.parse('$baseUrl/contests/$year'));
    if (response.statusCode == 200) {
      final contestData = json.decode(response.body);
      if (contestData.containsKey('contestants') &&
          contestData['contestants'] is List) {
        return List<dynamic>.from(contestData['contestants']);
      }
      return [];
    } else {
      throw Exception('Failed to load contestants for year $year');
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

  Future<String> convertCountryCodeToCountryName(String countryCode) async {
    final response =
        await client.get(Uri.parse('$baseUrl/countries/$countryCode'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to convert country code to country name');
    }
  }
}
