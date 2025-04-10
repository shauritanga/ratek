import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider =
    StateNotifierProvider<ConnectivityNotifier, bool>((ref) {
  return ConnectivityNotifier();
});

class ConnectivityNotifier extends StateNotifier<bool> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  final _connectivity = Connectivity();

  ConnectivityNotifier() : super(true) {
    _initConnectivity();
    _subscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      state = false;
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    state = results.any((result) => result != ConnectivityResult.none);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
