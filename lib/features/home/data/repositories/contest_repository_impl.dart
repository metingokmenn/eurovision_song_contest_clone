import 'package:eurovision_song_contest_clone/features/home/data/datasources/contest_local_data_source.dart';
import 'package:eurovision_song_contest_clone/features/home/data/datasources/contest_remote_data_source.dart';
import 'package:eurovision_song_contest_clone/features/home/domain/repositories/contest_repository.dart';
import 'package:eurovision_song_contest_clone/features/home/data/models/contest_model.dart';
import 'package:flutter/material.dart';

class ContestRepositoryImpl implements ContestRepository {
  final ContestRemoteDataSource remoteDataSource;
  final ContestLocalDataSource localDataSource;

  // Flag to determine whether to use only cache
  final bool _useCacheOnly;

  ContestRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    bool useCacheOnly = false,
  }) : _useCacheOnly = useCacheOnly;

  @override
  Future<List<int>> getContestYears() async {
    try {
      // Get data from local cache
      return await localDataSource.getContestYears();
    } catch (e) {
      if (_useCacheOnly) {
        // If we're cache-only, rethrow the exception
        debugPrint('Cache-only mode: Years not available in cache');
        rethrow;
      }

      debugPrint('Local data source failed: $e');
      // If local fails and we're not cache-only, fall back to remote
      return await remoteDataSource.getContestYears();
    }
  }

  @override
  Future<ContestModel> getContestByYear(int year) async {
    try {
      // Get data from local cache
      return await localDataSource.getContestByYear(year);
    } catch (e) {
      if (_useCacheOnly) {
        // If we're cache-only, rethrow the exception
        debugPrint(
            'Cache-only mode: Contest for year $year not available in cache');
        rethrow;
      }

      debugPrint('Local data source failed for year $year: $e');
      // If local fails and we're not cache-only, fall back to remote
      return await remoteDataSource.getContestByYear(year);
    }
  }

  @override
  Future<List<dynamic>> getContestantsByYear(int year) async {
    try {
      // Get data from local cache
      return await localDataSource.getContestantsByYear(year);
    } catch (e) {
      if (_useCacheOnly) {
        // If we're cache-only, rethrow the exception
        debugPrint(
            'Cache-only mode: Contestants for year $year not available in cache');
        rethrow;
      }

      debugPrint('Local data source failed for contestants in year $year: $e');
      // If local fails and we're not cache-only, fall back to remote
      return await remoteDataSource.getContestantsByYear(year);
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
  bool isDataAvailableInCache(int year) {
    try {
      return localDataSource.isYearDataLoaded(year);
    } catch (e) {
      return false;
    }
  }
}
