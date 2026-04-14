import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../network/network_info.dart';
import 'network_event.dart';
import 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  final NetworkInfo networkInfo;
  StreamSubscription? _subscription;

  NetworkBloc({required this.networkInfo}) : super(NetworkInitial()) {
    on<NetworkObserve>(_onObserve);
    on<NetworkNotify>(_onNotify);
  }

  Future<void> _onObserve(NetworkObserve event, Emitter<NetworkState> emit) async {
    final isConnected = await networkInfo.isConnected;
    add(NetworkNotify(isConnected: isConnected));

    _subscription?.cancel();
    _subscription = networkInfo.onConnectionChanged.listen((connected) {
      add(NetworkNotify(isConnected: connected));
    });
  }

  void _onNotify(NetworkNotify event, Emitter<NetworkState> emit) {
    if (event.isConnected) {
      emit(NetworkSuccess());
    } else {
      emit(NetworkFailure());
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
