import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_pay_slips_usecase.dart';
import 'pay_slip_event.dart';
import 'pay_slip_state.dart';

class PaySlipBloc extends Bloc<PaySlipEvent, PaySlipState> {
  final GetPaySlipsUseCase getPaySlipsUseCase;

  PaySlipBloc({required this.getPaySlipsUseCase}) : super(const PaySlipState()) {
    on<GetPaySlipsRequested>(_onGetPaySlipsRequested);
  }

  Future<void> _onGetPaySlipsRequested(
    GetPaySlipsRequested event,
    Emitter<PaySlipState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await getPaySlipsUseCase(
      employeeGUID: event.employeeGUID,
      month: event.month,
      forceRefresh: event.forceRefresh,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        error: failure.message,
      )),
      (paySlips) => emit(state.copyWith(
        isLoading: false,
        paySlips: paySlips,
      )),
    );
  }
}
