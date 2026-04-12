import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_pay_slips_usecase.dart';
import 'pay_slip_event.dart';
import 'pay_slip_state.dart';

class PaySlipBloc extends Bloc<PaySlipEvent, PaySlipState> {
  final GetPaySlipsUseCase getPaySlipsUseCase;

  PaySlipBloc({required this.getPaySlipsUseCase}) : super(PaySlipInitial()) {
    on<GetPaySlipsRequested>(_onGetPaySlipsRequested);
  }

  Future<void> _onGetPaySlipsRequested(
    GetPaySlipsRequested event,
    Emitter<PaySlipState> emit,
  ) async {
    emit(PaySlipLoading());
    final result = await getPaySlipsUseCase(
      employeeGUID: event.employeeGUID,
      month: event.month,
    );
    result.fold(
      (failure) => emit(PaySlipFailure(failure.message)),
      (paySlips) => emit(PaySlipLoaded(paySlips)),
    );
  }
}
