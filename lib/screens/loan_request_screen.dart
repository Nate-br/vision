// lib/screens/loan_request_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_text_field.dart';
import '../../services/telegram_service.dart';
import '../../services/storage_service.dart';
import '../../models/loan_application.dart';
import 'pending_loan_screen.dart';

class LoanRequestScreen extends StatefulWidget {
  const LoanRequestScreen({super.key});

  @override
  State<LoanRequestScreen> createState() => _LoanRequestScreenState();
}

class _LoanRequestScreenState extends State<LoanRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _amountController = TextEditingController();
  final _incomeController = TextEditingController();

  String? _selectedPurpose;
  String? _selectedEmploymentStatus;
  String? _preferredContact;

  bool _isLoading = true;
  bool _hasPendingLoan = false;

  final List<String> _loanPurposes = [
    'Personal Use',
    'Business',
    'Education',
    'Medical',
    'Home Improvement',
    'Debt Consolidation',
    'Other',
  ];

  final List<String> _employmentStatuses = [
    'Employed Full-Time',
    'Employed Part-Time',
    'Self-Employed',
    'Unemployed',
    'Retired',
    'Student',
  ];

  final List<String> _contactMethods = [
    'Phone',
    'Email',
    'WhatsApp',
  ];

  @override
  void initState() {
    super.initState();
    _checkPendingLoan();
  }

  /// Check if user already has a pending loan
  Future<void> _checkPendingLoan() async {
    final hasPending = await StorageService.hasPendingLoan();
    setState(() {
      _hasPendingLoan = hasPending;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _amountController.dispose();
    _incomeController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_preferredContact == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a contact method'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Create loan application object
      final application = LoanApplication(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        amount: _amountController.text,
        purpose: _selectedPurpose!,
        employment: _selectedEmploymentStatus!,
        income: _incomeController.text,
        contactMethod: _preferredContact!,
        submittedAt: DateTime.now(),
      );

      // Send to Telegram
      bool telegramSuccess = await TelegramService.sendLoanRequest(application);
      
      // Save locally
      bool storageSuccess = await StorageService.savePendingLoan(application);

      // Hide loading dialog
      if (mounted) Navigator.pop(context);

      // Show result
      if (telegramSuccess && storageSuccess) {
        _showSuccessDialog();
      } else {
        _showErrorDialog();
      }
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
            Text('Success!'),
          ],
        ),
        content: const Text(
          'Your loan request has been submitted successfully. '
          'We will contact you within 24 hours.\n\n'
          'You can check your application status anytime.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to home
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
        content: const Text(
          'Failed to submit your request. Please check your internet connection and try again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Navigate to pending loan screen
  void _viewPendingLoan() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PendingLoanScreen(),
      ),
    ).then((_) => _checkPendingLoan()); // Refresh when coming back
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Apply for Loan'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // If user has pending loan, show warning card
    if (_hasPendingLoan) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Apply for Loan'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.pending_actions,
                        size: 60,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Application Pending',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'You already have a loan application in progress. '
                      'Please wait for our response or cancel your current application to submit a new one.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textLight,
                          ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _viewPendingLoan,
                        icon: const Icon(Icons.visibility),
                        label: const Text('View Pending Application'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Go Back'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Normal form (rest of your existing form code)
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Apply for Loan'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fill in your details',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                'All fields marked with * are required',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textLight,
                    ),
              ),
              const SizedBox(height: 30),

              // Full Name
              CustomTextField(
                controller: _nameController,
                label: 'Full Name *',
                prefixIcon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Phone Number
              CustomTextField(
                controller: _phoneController,
                label: 'Phone Number *',
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.length < 10) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Email
              CustomTextField(
                controller: _emailController,
                label: 'Email Address *',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Loan Amount
              CustomTextField(
                controller: _amountController,
                label: 'Loan Amount (ETB) *',
                prefixIcon: Icons.attach_money,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter loan amount';
                  }
                  double? amount = double.tryParse(value);
                  if (amount == null) {
                    return 'Please enter a valid amount';
                  }
                  if (amount < LoanConstants.minLoanAmount) {
                    return 'Minimum loan amount is ETB ${LoanConstants.minLoanAmount}';
                  }
                  if (amount > LoanConstants.maxLoanAmount) {
                    return 'Maximum loan amount is ETB ${LoanConstants.maxLoanAmount}';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Loan Purpose
              DropdownButtonFormField<String>(
                value: _selectedPurpose,
                decoration: InputDecoration(
                  labelText: 'Loan Purpose *',
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: _loanPurposes.map((purpose) {
                  return DropdownMenuItem(
                    value: purpose,
                    child: Text(purpose),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPurpose = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select loan purpose';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Employment Status
              DropdownButtonFormField<String>(
                value: _selectedEmploymentStatus,
                decoration: InputDecoration(
                  labelText: 'Employment Status *',
                  prefixIcon: const Icon(Icons.work),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: _employmentStatuses.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedEmploymentStatus = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select employment status';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Monthly Income
              CustomTextField(
                controller: _incomeController,
                label: 'Monthly Income (ETB) *',
                prefixIcon: Icons.payments,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your monthly income';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Preferred Contact Method
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preferred Contact Method *',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: _contactMethods.map((method) {
                      return ChoiceChip(
                        label: Text(method),
                        selected: _preferredContact == method,
                        onSelected: (selected) {
                          setState(() {
                            _preferredContact = selected ? method : null;
                          });
                        },
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: _preferredContact == method
                              ? Colors.white
                              : Colors.black,
                        ),
                      );
                    }).toList(),
                  ),
                  if (_preferredContact == null)
                    const Padding(
                      padding: EdgeInsets.only(top: 8, left: 12),
                      child: Text(
                        'Please select a contact method',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Submit Request',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Terms and Conditions
              Text(
                'By submitting this form, you agree to our Terms & Conditions and Privacy Policy.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textLight,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}