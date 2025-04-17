import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamController<bool> connectionStatusController =
      StreamController<bool>.broadcast();

  ConnectivityService() {
    // Initialize the connectivity checking
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    // Check status right away on initialization
    checkConnection();
  }

  // Check current connection status
  Future<bool> checkConnection() async {
    bool isConnected = await _isConnected();
    connectionStatusController.add(isConnected);
    return isConnected;
  }

  // Internal helper to check actual connectivity
  Future<bool> _isConnected() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) {
      return false;
    }

    // Double-check with an actual connection test
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  // Update connection status when connectivity changes
  void _updateConnectionStatus(ConnectivityResult result) async {
    bool isConnected = await _isConnected();
    connectionStatusController.add(isConnected);
  }

  // Clean up resources
  void dispose() {
    connectionStatusController.close();
  }
}
