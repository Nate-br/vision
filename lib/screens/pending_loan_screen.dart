// lib/screens/pending_loan_screen.dart

import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../services/storage_service.dart';
import '../../services/telegram_service.dart';
import '../../models/loan_application.dart';

class PendingLoanScreen extends StatefulWidget {
  const PendingLoanScreen({super.key});

  @override
  State<PendingLoanScreen> createState() => _PendingLoanScreenState();
}

class _PendingLoanScreenState extends State<PendingLoanScreen> {
  LoanApplication? _pendingLoan;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPendingLoan();
  }

  Future<void> _loadPendingLoan() async {
    final loan = await StorageService.getPendingLoan();
    setState(() {
      _pendingLoan = loan;
      _isLoading = false;
    });
  }

  void _cancelLoan() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Application?'),
        content: const Text(
          'Are you sure you want to cancel this loan application? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No, Keep It'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              await _performCancellation();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _performCancellation() async {
    if (_pendingLoan == null) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Send cancellation to Telegram
    bool telegramSuccess = await TelegramService.sendCancellation(_pendingLoan!);
    
    // Delete from local storage
    bool storageSuccess = await StorageService.deletePendingLoan();

    // Hide loading
    if (mounted) Navigator.pop(context);

    // Show result
    if (telegramSuccess && storageSuccess) {
      _showSuccessDialog();
    } else {
      _showErrorDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 30),
            SizedBox(width: 10),
            Text('Cancelled'),
          ],
        ),
        content: const Text('Your loan application has been cancelled successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 30),
            SizedBox(width: 10),
            Text('Error'),
          ],
        ),
        content: const Text('Failed to cancel the application. Please try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pending Application'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pendingLoan == null
              ? const Center(child: Text('No pending application found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.pending_actions,
                              size: 60,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Application Under Review',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'We\'ll contact you within 24 hours',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Application Details
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Application Details',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 20),
                              _buildDetailRow('Application ID', _pendingLoan!.id),
                              _buildDetailRow('Name', _pendingLoan!.name),
                              _buildDetailRow('Phone', _pendingLoan!.phone),
                              _buildDetailRow('Email', _pendingLoan!.email),
                              const Divider(height: 30),
                              _buildDetailRow('Loan Amount', 'ETB ${_pendingLoan!.amount}'),
                              _buildDetailRow('Purpose', _pendingLoan!.purpose),
                              _buildDetailRow('Employment', _pendingLoan!.employment),
                              _buildDetailRow('Monthly Income', 'ETB ${_pendingLoan!.income}'),
                              const Divider(height: 30),
                              _buildDetailRow('Contact Method', _pendingLoan!.contactMethod),
                              _buildDetailRow(
                                'Submitted',
                                _formatDateTime(_pendingLoan!.submittedAt),
                              ),
                              _buildDetailRow('Status', _pendingLoan!.status.toUpperCase()),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Cancel Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _cancelLoan,
                          icon: const Icon(Icons.cancel),
                          label: const Text('Cancel Application'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red, width: 2),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} at ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }
}