import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eurovision_song_contest_clone/core/api/connectivity_service.dart';

class ConnectivityState {
  final bool isConnected;

  const ConnectivityState({
    this.isConnected = true,
  });

  ConnectivityState copyWith({
    bool? isConnected,
  }) {
    return ConnectivityState(
      isConnected: isConnected ?? this.isConnected,
    );
  }
}

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final ConnectivityService _connectivityService;
  StreamSubscription? _connectivitySubscription;

  ConnectivityCubit({
    required ConnectivityService connectivityService,
  })  : _connectivityService = connectivityService,
        super(const ConnectivityState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    // Initial connection check
    await checkConnection();

    // Listen for connection changes
    _connectivitySubscription = _connectivityService
        .connectionStatusController.stream
        .listen((isConnected) {
      emit(state.copyWith(isConnected: isConnected));
    });
  }

  Future<void> checkConnection() async {
    final isConnected = await _connectivityService.checkConnection();
    emit(state.copyWith(isConnected: isConnected));
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
