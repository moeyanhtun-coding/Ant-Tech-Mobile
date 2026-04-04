import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/attendance_repository.dart';

class ScanQRCodeParams {
  final String employeeGUID;
  final String locationGUID;

  ScanQRCodeParams({required this.employeeGUID, required this.locationGUID});
}

class ScanQRCodeUseCase implements UseCase<String, ScanQRCodeParams> {
  final AttendanceRepository repository;

  ScanQRCodeUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(ScanQRCodeParams params) async {
    return await repository.scanQRCode(
      employeeGUID: params.employeeGUID,
      locationGUID: params.locationGUID,
    );
  }
}
