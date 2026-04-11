import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/attendance_entity.dart';

class AttendanceCard extends StatelessWidget {
  final AttendanceEntity record;

  const AttendanceCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
        border: isDark
            ? Border.all(color: Colors.white.withValues(alpha: 0.05))
            : null,
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
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (record.shiftName != null)
                      Text(
                        record.shiftName!,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
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
                _buildTimeInfo(
                  'Check In',
                  _formatTime(record.checkInTime),
                  Icons.login_rounded,
                  Colors.green,
                  colorScheme,
                  hasLocation: record.checkInLatitude != null && record.checkInLongitude != null,
                ),
                _buildTimeInfo(
                  'Check Out',
                  _formatTime(record.checkOutTime),
                  Icons.logout_rounded,
                  Colors.orange,
                  colorScheme,
                  hasLocation: record.checkOutLatitude != null && record.checkOutLongitude != null,
                ),
                _buildTimeInfo(
                  'Total',
                  record.totalHours ?? '00:00',
                  Icons.timer_outlined,
                  Colors.blue,
                  colorScheme,
                ),
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

  String _formatTime(String? timeStr) {
    if (timeStr == null ||
        timeStr.isEmpty ||
        timeStr == '--:--' ||
        timeStr == '00:00')
      return '--:--';
    try {
      final DateFormat outputFormat = DateFormat('hh:mm a');
      DateTime dateTime;
      try {
        dateTime = DateFormat('HH:mm:ss').parse(timeStr);
      } catch (_) {
        try {
          dateTime = DateFormat('HH:mm').parse(timeStr);
        } catch (_) {
          return timeStr;
        }
      }
      return outputFormat.format(dateTime);
    } catch (e) {
      return timeStr;
    }
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    Color borderColor;

    if (status == 'Present') {
      bgColor = const Color(0xFFDCFCE7);
      textColor = const Color(0xFF166534);
      borderColor = const Color(0xFFBBF7D0);
    } else if (status == 'Absent') {
      bgColor = const Color(0xFFF3F4F6);
      textColor = const Color(0xFF1F2937);
      borderColor = const Color(0xFFE5E7EB);
    } else if (status.contains('Late') && status.contains('Early')) {
      // Late + Early Left
      bgColor = const Color(0xFFFEF3C7); // Amber 100
      textColor = const Color(0xFF92400E); // Amber 800
      borderColor = const Color(0xFFFDE68A); // Amber 200
    } else if (status.contains('Late')) {
      bgColor = const Color(0xFFFEE2E2);
      textColor = const Color(0xFF991B1B);
      borderColor = const Color(0xFFFECACA);
    } else if (status.contains('Early')) {
      bgColor = const Color(0xFFFEF9C3);
      textColor = const Color(0xFF854D0E);
      borderColor = const Color(0xFFFEF08A);
    } else {
      bgColor = const Color(0xFFDBEAFE);
      textColor = const Color(0xFF1E3A8A);
      borderColor = const Color(0xFFBFDBFE);
    }

    // Display override for refined labels
    String displayStatus = status;
    if (status == 'Late + EarlyLeave') displayStatus = 'Late + Early Left';
    if (status == 'EarlyLeave') displayStatus = 'Early Left';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        displayStatus,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildTimeInfo(
    String label,
    String time,
    IconData icon,
    Color color,
    ColorScheme colorScheme, {
    bool hasLocation = false,
  }) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(icon, size: 18, color: color.withValues(alpha: 0.7)),
            ),
            if (hasLocation)
              const Positioned(
                right: 0,
                top: 0,
                child: Icon(
                  Icons.location_on_rounded,
                  size: 8,
                  color: Colors.red,
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: colorScheme.onSurface.withValues(alpha: 0.5),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          time,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
