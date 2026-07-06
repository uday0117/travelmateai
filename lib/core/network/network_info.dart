import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:travelmateai/core/errors/exceptions.dart';

/// Checks device network connectivity.
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl(this._connectivity);

  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return _hasConnection(result);
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_hasConnection);
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any(
      (result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet ||
          result == ConnectivityResult.vpn,
    );
  }
}

/// Throws when offline and operation requires network.
Future<T> requireNetwork<T>({
  required Future<bool> Function() isConnected,
  required Future<T> Function() operation,
}) async {
  if (!await isConnected()) {
    throw const NetworkException('No internet connection');
  }
  return operation();
}
