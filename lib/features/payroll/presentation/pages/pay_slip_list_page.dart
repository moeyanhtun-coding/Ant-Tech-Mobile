import 'package:at_hr_mobile/core/bloc/network/network_bloc.dart';
import 'package:at_hr_mobile/core/bloc/network/network_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../bloc/pay_slip_bloc.dart';
import '../bloc/pay_slip_event.dart';
import '../bloc/pay_slip_state.dart';
import '../widgets/pay_slip_card.dart';

class PaySlipListPage extends StatefulWidget {
  final String employeeGUID;

  const PaySlipListPage({super.key, required this.employeeGUID});

  @override
  State<PaySlipListPage> createState() => _PaySlipListPageState();
}

class _PaySlipListPageState extends State<PaySlipListPage> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _fetchPaySlips();
  }

  void _fetchPaySlips() {
    final monthStr = DateFormat('yyyy-MM').format(_selectedDate);
    context.read<PaySlipBloc>().add(
      GetPaySlipsRequested(employeeGUID: widget.employeeGUID, month: monthStr),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _fetchPaySlips();
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
          'Payroll Records',
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 10.0,
                  ),
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
            onPressed: () => _selectDate(context),
            tooltip: 'Select Month',
          ),
        ],
      ),
      body: BlocListener<NetworkBloc, NetworkState>(
        listener: (context, state) {
          if (state is NetworkSuccess) {
            _fetchPaySlips();
          }
        },
        child: Column(
          children: [
            // Filter Summary
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
                    'Showing records for: ',
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
              child: BlocBuilder<PaySlipBloc, PaySlipState>(
                builder: (context, state) {
                  if (state is PaySlipLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PaySlipLoaded) {
                    if (state.paySlips.isEmpty) {
                      return _buildEmptyState(isDark);
                    }
                    return RefreshIndicator(
                      onRefresh: () async => _fetchPaySlips(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: state.paySlips.length,
                        itemBuilder: (context, index) {
                          return PaySlipCard(paySlip: state.paySlips[index]);
                        },
                      ),
                    );
                  } else if (state is PaySlipFailure) {
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
                            onPressed: _fetchPaySlips,
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
              Icons.payments_outlined,
              size: 64,
              color: Colors.grey.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Payslips Found',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'There are no payroll records for this period.',
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
