import 'package:eurovision_song_contest_clone/features/home/data/datasources/contest_remote_data_source.dart';
import 'package:eurovision_song_contest_clone/features/home/domain/repositories/contest_repository.dart';
import 'package:eurovision_song_contest_clone/features/home/data/models/contest_model.dart';
import 'package:flutter/material.dart';

class ContestRepositoryImpl implements ContestRepository {
  final ContestRemoteDataSource remoteDataSource;

  ContestRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<int>> getContestYears() async {
    try {
      // Get data from remote source
      return await remoteDataSource.getContestYears();
    } catch (e) {
      debugPrint('Remote data source failed: $e');
      throw Exception('Failed to get contest years: $e');
    }
  }

  @override
  Future<ContestModel> getContestByYear(int year) async {
    try {
      // Get data from remote source
      return await remoteDataSource.getContestByYear(year);
    } catch (e) {
      debugPrint('Remote data source failed for year $year: $e');
      throw Exception('Failed to get contest for year $year: $e');
    }
  }

  @override
  Future<List<dynamic>> getContestantsByYear(int year) async {
    try {
      // Get data from remote source
      return await remoteDataSource.getContestantsByYear(year);
    } catch (e) {
      debugPrint('Remote data source failed for contestants in year $year: $e');
      throw Exception('Failed to get contestants for year $year: $e');
    }
  }

  @override
  Future<List<int>> getJuniorContestYears() async {
    return await remoteDataSource.getJuniorContestYears();
  }

  @override
  Future<ContestModel> getJuniorContestByYear(int year) async {
    return await remoteDataSource.getJuniorContestByYear(year);
  }

  @override
  Future<String> convertCountryCodeToCountryName(String countryCode) async {
    return await remoteDataSource.convertCountryCodeToCountryName(countryCode);
  }

  /// Check if all required data for UI interactions is available in cache
  @override
  bool isDataAvailableInCache(int year) {
    // Since we're not using local cache anymore, always return false
    return false;
  }
}
