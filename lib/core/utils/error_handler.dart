import 'dart:io';

import 'package:flutter/material.dart';

class ErrorHandler {
  /// Show a user-friendly error message based on the exception type
  static void handleError(BuildContext context, Object error) {
    String message = _getErrorMessage(error);

    // Show a snackbar with the error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[800],
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Get a user-friendly error message based on the exception type
  static String _getErrorMessage(Object error) {
    if (error is SocketException) {
      return 'No internet connection. Please check your network settings.';
    } else if (error is HttpException) {
      return 'Could not connect to the server. Using cached data.';
    } else if (error is FormatException) {
      return 'Invalid response from server. Using cached data.';
    } else if (error.toString().contains('ClientException')) {
      return 'Network error. Using cached data.';
    } else if (error.toString().contains('Connection refused')) {
      return 'Connection refused. Using cached data.';
    }

    return 'An error occurred. Using cached data.';
  }

  /// Show a dialog with error and retry option
  static void showErrorDialog(
      BuildContext context, Object error, VoidCallback onRetry) {
    String message = _getErrorMessage(error);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connection Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onRetry();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
