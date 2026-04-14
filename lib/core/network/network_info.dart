import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectionChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final results = await connectivity.checkConnectivity();
    final hasInterface = _hasConnection(results);
    if (!hasInterface) return false;
    
    try {
      final lookup = await InternetAddress.lookup('google.com');
      return lookup.isNotEmpty && lookup[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  Stream<bool> get onConnectionChanged =>
      connectivity.onConnectivityChanged.asyncMap((results) async {
        final hasInterface = _hasConnection(results);
        if (!hasInterface) return false;
        
        try {
          final lookup = await InternetAddress.lookup('google.com');
          return lookup.isNotEmpty && lookup[0].rawAddress.isNotEmpty;
        } on SocketException catch (_) {
          return false;
        }
      });

  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((r) =>
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.ethernet);
  }
}
