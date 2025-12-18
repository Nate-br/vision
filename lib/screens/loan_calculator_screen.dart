import 'package:flutter/material.dart';
import 'dart:math';
import '../../utils/constants.dart';
import 'loan_request_screen.dart';

class LoanCalculatorScreen extends StatefulWidget {
  const LoanCalculatorScreen({super.key});

  @override
  State<LoanCalculatorScreen> createState() => _LoanCalculatorScreenState();
}

class _LoanCalculatorScreenState extends State<LoanCalculatorScreen> {
  double _loanAmount = 5000;
  int _selectedTermMonths = 12;
  double _interestRate = LoanConstants.defaultInterestRate;
  
  double _monthlyPayment = 0;
  double _totalPayment = 0;
  double _totalInterest = 0;

  @override
  void initState() {
    super.initState();
    _calculateLoan();
  }

  void _calculateLoan() {
    // Monthly interest rate
    double monthlyRate = _interestRate / 100 / 12;
    
    // Calculate monthly payment using formula
    // M = P [ i(1 + i)^n ] / [ (1 + i)^n – 1]
    double temp = pow(1 + monthlyRate, _selectedTermMonths).toDouble();
    _monthlyPayment = _loanAmount * (monthlyRate * temp) / (temp - 1);
    
    _totalPayment = _monthlyPayment * _selectedTermMonths;
    _totalInterest = _totalPayment - _loanAmount;
    
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Loan Calculator'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calculate Your Loan',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'Adjust the values to see your monthly payment',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textLight,
                  ),
            ),
            const SizedBox(height: 30),
            
            // Loan Amount Card
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Loan Amount',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          ('${AppStrings.currencySymbol}\u2008${_loanAmount.toStringAsFixed(0)}'),
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: AppColors.primary,
                        inactiveTrackColor: AppColors.primary.withOpacity(0.2),
                        thumbColor: AppColors.primary,
                        overlayColor: AppColors.primary.withOpacity(0.2),
                        trackHeight: 6,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 12,
                        ),
                      ),
                      child: Slider(
                        value: _loanAmount,
                        min: LoanConstants.minLoanAmount,
                        max: LoanConstants.maxLoanAmount,
                        divisions: 49,
                        label: ('${AppStrings.currencySymbol}\u2008${_loanAmount.toStringAsFixed(0)}'),
                        onChanged: (value) {
                          setState(() {
                            _loanAmount = value;
                            _calculateLoan();
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${LoanConstants.minLoanAmount.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '\$${LoanConstants.maxLoanAmount.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Loan Term Card
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
                      'Loan Term',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      children: LoanConstants.loanTermsMonths.map((months) {
                        return ChoiceChip(
                          label: Text('$months months'),
                          selected: _selectedTermMonths == months,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedTermMonths = months;
                                _calculateLoan();
                              });
                            }
                          },
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: _selectedTermMonths == months
                                ? Colors.white
                                : Colors.black,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Interest Rate Card
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Interest Rate (Annual)',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '${_interestRate.toStringAsFixed(1)}%',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: AppColors.primary,
                        inactiveTrackColor: AppColors.primary.withOpacity(0.2),
                        thumbColor: AppColors.primary,
                        overlayColor: AppColors.primary.withOpacity(0.2),
                        trackHeight: 6,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 12,
                        ),
                      ),
                      child: Slider(
                        value: _interestRate,
                        min: 5,
                        max: 25,
                        divisions: 40,
                        label: '${_interestRate.toStringAsFixed(1)}%',
                        onChanged: (value) {
                          setState(() {
                            _interestRate = value;
                            _calculateLoan();
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '5%',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '25%',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            // Results Card
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Payment Details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 20),
                  _buildResultItem(
                    context,
                    'Monthly Payment',
                    ('${AppStrings.currencySymbol}\u2008${_monthlyPayment.toStringAsFixed(2)}'),
                    Icons.calendar_month,
                  ),
                  const Divider(color: Colors.white30, height: 30),
                  _buildResultItem(
                    context,
                    'Total Payment',
                    ('${AppStrings.currencySymbol}\u2008${_totalPayment.toStringAsFixed(2)}'),
                    Icons.payment,
                  ),
                  const Divider(color: Colors.white30, height: 30),
                  _buildResultItem(
                    context,
                    'Total Interest',
                    ('${AppStrings.currencySymbol}\u2008${_totalInterest.toStringAsFixed(2)}'),
                    Icons.percent,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            // Apply Now Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoanRequestScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Apply Now',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white70, size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}