import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/pay_slip_entity.dart';

class PaySlipDetailPage extends StatelessWidget {
  final PaySlipEntity paySlip;

  const PaySlipDetailPage({super.key, required this.paySlip});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final currencyFormat = NumberFormat.currency(
      symbol: paySlip.currencySymbol ?? 'Ks',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Pay Slip Detail',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Employee Profile Section
            _buildSection(
              context,
              'Employee Details',
              Icons.person_outline_rounded,
              child: Column(
                children: [
                  _buildDetailRow('Name', paySlip.employeeName, isDark: isDark),
                  _buildDetailRow('Department', paySlip.departmentName, isDark: isDark),
                  _buildDetailRow('Position', paySlip.employeeTypeName, isDark: isDark),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Period Section
            _buildSection(
              context,
              'Salary Period',
              Icons.calendar_today_rounded,
              child: Column(
                children: [
                  _buildDetailRow('Month', paySlip.salaryMonth, isDark: isDark),
                  _buildDetailRow('Pay Period', paySlip.payPeriod, isDark: isDark),
                  _buildDetailRow('Payment Date', paySlip.paymentDate, isDark: isDark),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Attendance Section (Moved from card)
            _buildSection(
              context,
              'Attendance Summary',
              Icons.analytics_outlined,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Present', paySlip.presentDays.toString(), Icons.check_circle_outline, Colors.green),
                  _buildStatItem('Absent', paySlip.absentDays.toString(), Icons.cancel_outlined, Colors.red),
                  _buildStatItem('Leave', paySlip.leaveDays.toString(), Icons.event_note, Colors.blue),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Earnings Section
            _buildSection(
              context,
              'Earnings',
              Icons.add_circle_outline_rounded,
              headerColor: Colors.green,
              child: Column(
                children: [
                  _buildDetailRow(
                    'Basic Salary',
                    currencyFormat.format(paySlip.basicSalary),
                    isDark: isDark,
                  ),
                  if (paySlip.earnings.isNotEmpty) ...[
                    const Divider(height: 24),
                    ...paySlip.earnings.map((e) => _buildDetailRow(
                          e.earningName,
                          currencyFormat.format(e.amount),
                          valueColor: Colors.green,
                          isDark: isDark,
                        )),
                  ],
                  const Divider(height: 24),
                  _buildDetailRow(
                    'Total Allowances',
                    currencyFormat.format(paySlip.totalAllowances),
                    isBold: true,
                    valueColor: Colors.green,
                    isDark: isDark,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Deductions Section
            _buildSection(
              context,
              'Deductions',
              Icons.remove_circle_outline_rounded,
              headerColor: Colors.red,
              child: Column(
                children: [
                  if (paySlip.deductions.isEmpty)
                    Text(
                      'No deductions this month',
                      style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
                    )
                  else
                    ...paySlip.deductions.map((e) => _buildDetailRow(
                          e.deductionName,
                          currencyFormat.format(e.amount),
                          valueColor: Colors.red,
                          isDark: isDark,
                        )),
                  const Divider(height: 24),
                  _buildDetailRow(
                    'Total Deductions',
                    currencyFormat.format(paySlip.totalDeductions),
                    isBold: true,
                    valueColor: Colors.red,
                    isDark: isDark,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Net Salary Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NET SALARY',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withValues(alpha: 0.8),
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        'Take Home Pay',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    currencyFormat.format(paySlip.netSalary),
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon, {
    required Widget child,
    Color? headerColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, size: 20, color: headerColor ?? colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: headerColor ?? colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: isDark ? Colors.white70 : Colors.grey[600],
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: valueColor ?? (isDark ? Colors.white : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
