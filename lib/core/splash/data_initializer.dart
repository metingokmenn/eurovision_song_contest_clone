import 'dart:async';
import 'package:flutter/material.dart';

enum DataLoadStatus { notStarted, inProgress, completed, error }

class DataInitializer {
  DataLoadStatus _status = DataLoadStatus.notStarted;
  String? _errorMessage;
  double _progress = 0.0;
  String _loadingMessage = 'Initializing...';

  // Add a stream controller for progress updates
  final StreamController<double> _progressController =
      StreamController<double>.broadcast();
  Stream<double> get progressStream => _progressController.stream;

  // Add timeout to prevent waiting indefinitely
  static const int maxWaitTimeSeconds = 3;

  // Getters
  DataLoadStatus get status => _status;
  String? get errorMessage => _errorMessage;
  double get progress => _progress;
  String get loadingMessage => _loadingMessage;

  /// Initialize required data for the app
  Future<bool> initializeAppData() async {
    try {
      _status = DataLoadStatus.inProgress;
      _progress = 0.0;
      _progressController.add(_progress);
      _loadingMessage = 'Initializing...';

      // Simulate data initialization
      await Future.delayed(const Duration(seconds: 1));
      _updateProgress(0.5);
      _loadingMessage = 'Getting ready...';

      await Future.delayed(const Duration(seconds: 1));
      _updateProgress(1.0);
      _loadingMessage = 'Ready';

      _status = DataLoadStatus.completed;
      return true;
    } catch (e) {
      _status = DataLoadStatus.error;
      _errorMessage = 'Failed to initialize app data: $e';
      return false;
    }
  }

  /// Update the loading progress
  void _updateProgress(double value) {
    _progress = value;
    _progressController.add(value);
  }

  /// Retry initialization if it failed
  Future<bool> retry() async {
    _errorMessage = null;
    return initializeAppData();
  }

  void dispose() {
    _progressController.close();
  }
}
