import 'dart:convert';
import 'package:eurovision_song_contest_clone/core/constants/constant_index.dart';
import 'package:eurovision_song_contest_clone/features/home/data/models/contest_model.dart';
import 'package:http/http.dart' as http;

class SearchRemoteDataSource {
  final http.Client client;

  SearchRemoteDataSource({required this.client});

  Future<List<ContestModel>> searchContests(String query) async {
    try {
      // For demo purposes, search through available contests
      // In a real implementation, we would make an API call to a search endpoint
      final response = await client.get(
        Uri.parse('${Consts.baseUrl}/contests/years'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> years = json.decode(response.body);

        // Filter years that contain the query string
        final filteredYears = years
            .cast<int>()
            .where((year) => year.toString().contains(query))
            .toList();

        if (filteredYears.isEmpty) {
          return [];
        }

        // Get details for each matching year
        List<ContestModel> results = [];
        for (final year in filteredYears.take(5)) {
          // Limit to 5 results
          try {
            final contestResponse = await client.get(
              Uri.parse('${Consts.baseUrl}/contests/$year'),
            );
            if (contestResponse.statusCode == 200) {
              results.add(
                  ContestModel.fromJson(json.decode(contestResponse.body)));
            }
          } catch (e) {
            // Continue with next year
          }
        }

        return results;
      } else {
        // Just return empty list on error - more user-friendly for search
        return [];
      }
    } catch (e) {
      // Return empty list instead of throwing - more user-friendly for search
      return [];
    }
  }
}
