import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/attendance_entity.dart';

class AttendanceCard extends StatelessWidget {
  final AttendanceEntity record;

  const AttendanceCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(record.date),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    if (record.shiftName != null)
                      Text(
                        record.shiftName!,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
                _buildStatusBadge(record.attendanceStatus),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTimeInfo('Check In', record.checkInTime ?? '--:--', Icons.login_rounded, Colors.green),
                _buildTimeInfo('Check Out', record.checkOutTime ?? '--:--', Icons.logout_rounded, Colors.orange),
                _buildTimeInfo('Total', record.totalHours ?? '00:00', Icons.timer_outlined, Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('EEE, MMM dd, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    Color borderColor;

    if (status.contains('Present')) {
      bgColor = const Color(0xFFDCFCE7);
      textColor = const Color(0xFF166534);
      borderColor = const Color(0xFFBBF7D0);
    } else if (status.contains('Late')) {
      bgColor = const Color(0xFFFEE2E2);
      textColor = const Color(0xFF991B1B);
      borderColor = const Color(0xFFFECACA);
    } else if (status.contains('Early')) {
      bgColor = const Color(0xFFFEF9C3);
      textColor = const Color(0xFF854D0E);
      borderColor = const Color(0xFFFEF08A);
    } else if (status == 'Absent') {
      bgColor = const Color(0xFFF3F4F6);
      textColor = const Color(0xFF1F2937);
      borderColor = const Color(0xFFE5E7EB);
    } else {
      bgColor = const Color(0xFFDBEAFE);
      textColor = const Color(0xFF1E3A8A);
      borderColor = const Color(0xFFBFDBFE);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        status,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildTimeInfo(String label, String time, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 18, color: color.withValues(alpha: 0.7)),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          time,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
