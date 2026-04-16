import 'package:equatable/equatable.dart';

class AttendanceSummaryEntity extends Equatable {
  final int present;
  final int late;
  final int earlyLeft;
  final int lateAndEarlyLeft;
  final int pendingRequestCount;
  final String month;

  const AttendanceSummaryEntity({
    required this.present,
    required this.late,
    required this.earlyLeft,
    required this.lateAndEarlyLeft,
    required this.pendingRequestCount,
    required this.month,
  });

  int get total => present + late + earlyLeft + lateAndEarlyLeft;

  @override
  List<Object?> get props => [
        present,
        late,
        earlyLeft,
        lateAndEarlyLeft,
        pendingRequestCount,
        month,
      ];
}
