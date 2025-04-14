import 'dart:convert';

import 'package:eurovision_song_contest_clone/features/contest/data/models/contest_model.dart';
import 'package:eurovision_song_contest_clone/features/contestant/data/models/contestant_model.dart';
import 'package:http/http.dart' as http;

class SearchRemoteDataSource {
  final String baseUrl = 'https://eurovisionapi.runasp.net/api';
  final http.Client client;

  SearchRemoteDataSource({required this.client});

  Future<List<ContestModel>> searchContests(String query) async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/contests'));

      if (response.statusCode == 200) {
        final List<dynamic> contestsJson = json.decode(response.body);
        final List<ContestModel> allContests = contestsJson
            .map((json) => ContestModel.fromJson(json as Map<String, dynamic>))
            .toList();

        // Filter contests based on the query
        final lowercaseQuery = query.toLowerCase();
        return allContests.where((contest) {
          return (contest.year.toString().contains(lowercaseQuery)) ||
              (contest.city?.toLowerCase().contains(lowercaseQuery) ?? false) ||
              (contest.country?.toLowerCase().contains(lowercaseQuery) ??
                  false) ||
              (contest.slogan?.toLowerCase().contains(lowercaseQuery) ??
                  false) ||
              (contest.arena?.toLowerCase().contains(lowercaseQuery) ?? false);
        }).toList();
      } else {
        throw Exception('Failed to load contests');
      }
    } catch (e) {
      print('Error in searchContests: $e');
      return [];
    }
  }
}
