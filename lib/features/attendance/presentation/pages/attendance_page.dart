import 'package:at_hr_mobile/core/bloc/network/network_bloc.dart';
import 'package:at_hr_mobile/core/bloc/network/network_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../bloc/attendance_bloc.dart';
import '../bloc/attendance_event.dart';
import '../bloc/attendance_state.dart';
import '../widgets/attendance_card.dart';
import '../widgets/attendance_request_card.dart';
import '../widgets/attendance_request_dialog.dart';

class AttendancePage extends StatefulWidget {
  final String employeeGUID;
  final int initialTabIndex;

  const AttendancePage({
    super.key,
    required this.employeeGUID,
    this.initialTabIndex = 0,
  });

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage>
    with SingleTickerProviderStateMixin {
  DateTime _selectedMonth = DateTime.now();
  late TabController _tabController;
  int _activeTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _activeTabIndex = widget.initialTabIndex;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _tabController.addListener(_handleTabSelection);
    _fetchAllData();
  }

  void _handleTabSelection() {
    if (_tabController.index != _activeTabIndex) {
      setState(() {
        _activeTabIndex = _tabController.index;
      });
      // No re-fetch needed on tab change because we pre-fetch both!
    }
  }

  void _fetchAllData({bool forceRefresh = false}) {
    final monthStr = DateFormat('yyyy-MM').format(_selectedMonth);
    context.read<AttendanceBloc>().add(
      FetchAllAttendanceDataRequested(
        employeeGUID: widget.employeeGUID,
        month: monthStr,
        forceRefresh: forceRefresh,
      ),
    );
  }

  Future<void> _onRefresh() async {
    _fetchAllData(forceRefresh: true);
    await context.read<AttendanceBloc>().stream.firstWhere(
      (state) => !state.isLoadingRecords && !state.isLoadingRequests,
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
      _fetchAllData();
    }
  }

  void _showRequestDialog() {
    showDialog(
      context: context,
      builder: (context) =>
          AttendanceRequestDialog(employeeGUID: widget.employeeGUID),
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Attendance',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        actions: [
          BlocBuilder<NetworkBloc, NetworkState>(
            builder: (context, state) {
              if (state is NetworkFailure) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Chip(
                    backgroundColor: Colors.red.withOpacity(0.1),
                    side: const BorderSide(color: Colors.redAccent),
                    label: Text(
                      'Offline',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month_rounded),
            onPressed: () => _selectMonth(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          indicatorColor: colorScheme.primary,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.5),
          tabs: const [
            Tab(text: 'Records'),
            Tab(text: 'Requests'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showRequestDialog,
        backgroundColor: colorScheme.primary,
        icon: const Icon(Icons.add_task_rounded, color: Colors.white),
        label: Text(
          'Request',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: BlocListener<AttendanceBloc, AttendanceState>(
        listenWhen: (previous, current) =>
            previous.qrScanMessage != current.qrScanMessage ||
            previous.qrScanError != current.qrScanError ||
            previous.submitRequestMessage != current.submitRequestMessage ||
            previous.submitRequestError != current.submitRequestError,
        listener: (context, state) {
          if (state.qrScanMessage != null) {
            // Optional feedback for scan success, but usually handled in scanner page
          }

          if (state.submitRequestMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.submitRequestMessage!),
                backgroundColor: Colors.green,
              ),
            );
            _fetchAllData(forceRefresh: true);
          } else if (state.submitRequestError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.submitRequestError!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Column(
          children: [
            _buildMonthSelectorHeader(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildAttendanceList(), _buildRequestList()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceList() {
    return BlocBuilder<AttendanceBloc, AttendanceState>(
      builder: (context, state) {
        if (state.isLoadingRecords && state.records.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.records.isEmpty) {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: _buildEmptyState(
              'No Records Found',
              'There are no attendance records for this period.',
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
            itemCount: state.records.length,
            itemBuilder: (context, index) {
              return AttendanceCard(record: state.records[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildRequestList() {
    return BlocBuilder<AttendanceBloc, AttendanceState>(
      builder: (context, state) {
        if (state.isLoadingRequests && state.requests.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.requests.isEmpty) {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: _buildEmptyState(
              'No Requests Found',
              'There are no attendance requests for this period.',
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
            itemCount: state.requests.length,
            itemBuilder: (context, index) {
              return AttendanceRequestCard(request: state.requests[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildMonthSelectorHeader() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(color: colorScheme.primary.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.filter_list_rounded, size: 18, color: colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            'Showing for: ',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          Text(
            DateFormat('MMMM yyyy').format(_selectedMonth),
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
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
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
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
                    onPressed: _fetchAllData,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
