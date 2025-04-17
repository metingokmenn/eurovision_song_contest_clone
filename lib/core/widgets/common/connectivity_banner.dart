import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eurovision_song_contest_clone/core/api/connectivity_service.dart';
import 'package:eurovision_song_contest_clone/core/connectivity/cubit/connectivity_cubit.dart';

class ConnectivityBanner extends StatelessWidget {
  final ConnectivityService connectivityService;

  const ConnectivityBanner({
    super.key,
    required this.connectivityService,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConnectivityCubit(
        connectivityService: connectivityService,
      ),
      child: const ConnectivityBannerView(),
    );
  }
}

class ConnectivityBannerView extends StatelessWidget {
  const ConnectivityBannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityState>(
      builder: (context, state) {
        // Only show banner when offline
        if (state.isConnected) {
          return const SizedBox.shrink();
        }

        return Container(
          color: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi_off,
                color: Colors.white,
                size: 18.0,
              ),
              const SizedBox(width: 8.0),
              const Expanded(
                child: Text(
                  'You\'re offline. Using cached data.',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              InkWell(
                onTap: () =>
                    context.read<ConnectivityCubit>().checkConnection(),
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
