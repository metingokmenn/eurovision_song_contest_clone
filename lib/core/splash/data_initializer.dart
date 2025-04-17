import 'dart:async';
import 'package:eurovision_song_contest_clone/core/data/app_data_manager.dart';

enum DataLoadStatus { notStarted, inProgress, completed, error }

class DataInitializer {
  final AppDataManager _dataManager;
  DataLoadStatus _status = DataLoadStatus.notStarted;
  String? _errorMessage;
  double _progress = 0.0;
  String _loadingMessage = 'Initializing...';
  Timer? _checkLoadingTimer;

  // Add a stream controller for progress updates
  final StreamController<double> _progressController =
      StreamController<double>.broadcast();
  Stream<double> get progressStream => _progressController.stream;

  // Add timeout to prevent waiting indefinitely
  static const int maxWaitTimeSeconds = 10;

  DataInitializer({AppDataManager? dataManager})
      : _dataManager = dataManager ?? AppDataManager();

  // Getters
  DataLoadStatus get status => _status;
  String? get errorMessage => _errorMessage;
  double get progress => _progress;
  String get loadingMessage => _loadingMessage;

  /// Initialize all required data for the app
  Future<bool> initializeAppData() async {
    try {
      _status = DataLoadStatus.inProgress;
      _progress = 0.0;
      _progressController.add(_progress);
      _loadingMessage = 'Initializing...';

      // Initialize data manager
      await _dataManager.initialize();
      _updateProgress(0.1);
      _loadingMessage = 'Loading years...';

      // Start a timer to periodically check the loading progress
      _checkLoadingTimer =
          Timer.periodic(const Duration(milliseconds: 500), (timer) {
        _checkLoadingStatus();
      });

      // Load initial data - this will start the background loading process
      await _dataManager.loadInitialData();

      // Wait until the latest year data is loaded or timeout occurs
      final startTime = DateTime.now();
      bool timeoutReached = false;

      while (!_dataManager.isLoadingComplete && !timeoutReached) {
        // Check if timeout reached
        timeoutReached =
            DateTime.now().difference(startTime).inSeconds > maxWaitTimeSeconds;

        if (timeoutReached) {
          debugPrint('Timeout reached while waiting for data loading');
          break;
        }

        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Consider it a success if we have at least one year loaded,
      // even if all years haven't finished loading yet
      final hasMinimumData = _dataManager.contestYears != null &&
          _dataManager.contestYears!.isNotEmpty &&
          _dataManager.contests.isNotEmpty;

      _checkLoadingTimer?.cancel();
      _updateProgress(1.0);
      _loadingMessage = 'Ready';

      _status = DataLoadStatus.completed;

      // Continue loading in background but don't wait for it
      if (!_dataManager.isLoadingComplete && hasMinimumData) {
        debugPrint(
            'Proceeding with partial data, loading will continue in background');
      }

      return hasMinimumData;
    } catch (e) {
      _checkLoadingTimer?.cancel();
      _status = DataLoadStatus.error;
      _errorMessage = 'Failed to initialize app data: $e';
      return false;
    }
  }

  /// Check the loading status of the AppDataManager
  void _checkLoadingStatus() {
    final years = _dataManager.contestYears ?? [];
    final contests = _dataManager.contests;

    if (years.isEmpty) {
      _updateProgress(0.1);
      _loadingMessage = 'Loading years...';
      return;
    }

    // If we have loaded the latest year, consider it enough for proceeding
    final loadedYears = contests.length;
    final totalYears = years.length;

    if (loadedYears == 0) {
      _updateProgress(0.2);
      _loadingMessage = 'Loading latest contest...';
    } else if (loadedYears < totalYears) {
      // We have at least one year, calculate progress
      // We only need the most recent year for initial display,
      // so consider progress 80% complete once we have at least one year
      final progressValue = 0.2 + (loadedYears / totalYears * 0.2) + 0.6;
      _updateProgress(progressValue > 1.0 ? 1.0 : progressValue);
      _loadingMessage = 'Loading contest data ($loadedYears/$totalYears)';
    } else {
      _updateProgress(1.0);
      _loadingMessage = 'Ready';
      _checkLoadingTimer?.cancel();
    }

    // If loading is complete or we have enough data, update status
    if (_dataManager.isLoadingComplete) {
      _updateProgress(1.0);
      _loadingMessage = 'Ready';
      _checkLoadingTimer?.cancel();
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

  void debugPrint(String message) {
    // Use Flutter's debugPrint
    debugPrint('[DataInitializer] $message');
  }

  /// Close resources
  void dispose() {
    _checkLoadingTimer?.cancel();
    _progressController.close();
  }
}
