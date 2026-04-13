import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../bloc/duty_roster_bloc.dart';
import '../bloc/duty_roster_event.dart';
import '../bloc/duty_roster_state.dart';
import '../widgets/duty_assignment_card.dart';

class DutyRosterPage extends StatefulWidget {
  final String employeeGUID;

  const DutyRosterPage({super.key, required this.employeeGUID});

  @override
  State<DutyRosterPage> createState() => _DutyRosterPageState();
}

class _DutyRosterPageState extends State<DutyRosterPage> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _fetchDutyRoster();
  }

  void _fetchDutyRoster() {
    final monthStr = DateFormat('yyyy-MM').format(_selectedDate);
    context.read<DutyRosterBloc>().add(GetDutyRosterAssignmentsRequested(
          employeeGUID: widget.employeeGUID,
          month: monthStr,
        ));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _fetchDutyRoster();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Duty Roster',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_rounded),
            onPressed: () => _selectDate(context),
            tooltip: 'Select Month',
          ),
        ],
      ),
      body: Column(
        children: [
          // Month Indicator
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.filter_list_rounded,
                  size: 18,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Showing schedule for: ',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  DateFormat('MMMM yyyy').format(_selectedDate),
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: BlocBuilder<DutyRosterBloc, DutyRosterState>(
              builder: (context, state) {
                if (state is DutyRosterLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DutyRosterLoaded) {
                  if (state.assignments.isEmpty) {
                    return _buildEmptyState(isDark);
                  }
                  return RefreshIndicator(
                    onRefresh: () async => _fetchDutyRoster(),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: state.assignments.length,
                      itemBuilder: (context, index) {
                        return DutyAssignmentCard(
                          assignment: state.assignments[index],
                        );
                      },
                    ),
                  );
                } else if (state is DutyRosterFailure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 60,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(state.message, style: GoogleFonts.poppins()),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchDutyRoster,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_busy_rounded,
              size: 64,
              color: Colors.grey.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Assignments Found',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You don\'t have any work shifts for this month.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
