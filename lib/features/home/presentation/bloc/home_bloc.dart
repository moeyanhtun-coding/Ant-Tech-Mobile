import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetProfileUseCase getProfileUseCase;

  HomeBloc({required this.getProfileUseCase}) : super(HomeInitial()) {
    on<GetProfileRequested>(_onGetProfileRequested);
  }

  Future<void> _onGetProfileRequested(
    GetProfileRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    final result = await getProfileUseCase(NoParams());

    result.fold(
      (failure) => emit(HomeFailure(message: failure.message)),
      (profile) => emit(HomeLoaded(profile: profile)),
    );
  }
}
