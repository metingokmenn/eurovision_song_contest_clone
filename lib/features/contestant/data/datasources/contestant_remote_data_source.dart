import 'dart:convert';

import 'package:eurovision_song_contest_clone/features/contestant/data/models/contestant_model.dart';
import 'package:http/http.dart' as http;

class ContestantRemoteDataSource {
  final String baseUrl = 'https://eurovisionapi.runasp.net/api';
  final http.Client client;

  ContestantRemoteDataSource({required this.client});

  Future<ContestantModel> getContestantByContestYear(int year, int id) async {
    final response =
        await client.get(Uri.parse('$baseUrl/contests/$year/contestants/$id'));
    if (response.statusCode == 200) {
      return ContestantModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load contestants for year $year');
    }
  }

  Future<List<ContestantModel>> getContestantsByContestYear(int year) async {
    final response = await client.get(Uri.parse('$baseUrl/contests/$year'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final contestantsJson = data['contestants'] as List;
      return contestantsJson
          .map((e) => ContestantModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load contestants for year $year');
    }
  }
}
