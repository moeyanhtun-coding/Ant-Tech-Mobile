import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../bloc/attendance_bloc.dart';
import '../bloc/attendance_event.dart';
import '../bloc/attendance_state.dart';
import '../widgets/attendance_card.dart';

class AttendancePage extends StatefulWidget {
  final String employeeGUID;

  const AttendancePage({super.key, required this.employeeGUID});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  DateTime _selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchAttendance();
  }

  void _fetchAttendance() {
    final monthStr = DateFormat('yyyy-MM').format(_selectedMonth);
    context.read<AttendanceBloc>().add(
          GetAttendanceRequested(
            employeeGUID: widget.employeeGUID,
            month: monthStr,
          ),
        );
  }

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? picked = await showMonthPicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedMonth) {
      setState(() {
        _selectedMonth = picked;
      });
      _fetchAttendance();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: Text(
          'Attendance Record',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_rounded),
            onPressed: () => _selectMonth(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildMonthSelectorHeader(),
          Expanded(
            child: BlocBuilder<AttendanceBloc, AttendanceState>(
              builder: (context, state) {
                if (state is AttendanceLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AttendanceLoaded) {
                  if (state.records.isEmpty) {
                    return _buildEmptyState();
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: state.records.length,
                    itemBuilder: (context, index) {
                      return AttendanceCard(record: state.records[index]);
                    },
                  );
                } else if (state is AttendanceFailure) {
                  return _buildErrorState(state.message);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSelectorHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selected Month',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                DateFormat('MMMM yyyy').format(_selectedMonth),
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () => _selectMonth(context),
            icon: const Icon(Icons.edit_calendar_rounded, size: 18),
            label: const Text('Change'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2193b0).withValues(alpha: 0.1),
              foregroundColor: const Color(0xFF2193b0),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No records found for this month',
            style: GoogleFonts.poppins(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.grey[800]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _fetchAttendance,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
