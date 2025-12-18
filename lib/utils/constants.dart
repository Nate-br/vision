import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF87CEEB);      // Sky Blue
  static const Color secondary = Color(0xFF50C878);    // Money Green
  static const Color accent = Color(0xFFFFD700);       // Gold
  static const Color background = Color(0xFFF8F9FA);
  static const Color textDark = Color(0xFF212121);
  static const Color textLight = Color(0xFF757575);
  static const Color cardBackground = Colors.white;
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
}

class AppStrings {
  static const String appName = 'Vision Loans';
  static const String companyName = 'Vision for a Better Life SLA';
  static const String tagline = 'Your Vision, Our Support';
  static const String motto = 'Building Better Futures Together';
  static const String email = 'info@visionloans.com';
  static const String phone = '+251 911 234 567';
  static const String address = 'Mehal Adama MKC, Addis Ababa, Ethiopia';
  static const String workingHours = 'Mon-Fri: 8:30 AM - 5:30 PM\nSat: 9:00 AM - 1:00 PM';
  static const String currencySymbol = 'ETB';
  static const String currencyFormat = '{{currency}}';
}

class LoanConstants {
  static const double minLoanAmount = 5000;      // ETB
  static const double maxLoanAmount = 500000;    // ETB
  static const double defaultInterestRate = 15.0; // Annual percentage
  static const List<int> loanTermsMonths = [6, 12, 24, 36, 48, 60];
  static const String currency = 'ETB';
}

class LoanProducts {
  static const List<Map<String, dynamic>> products = [
    {
      'title': 'Personal Loan',
      'description': 'Quick personal loans for your immediate needs',
      'minAmount': 5000,
      'maxAmount': 100000,
      'interestRate': '15%',
      'maxTerm': '24 months',
      'icon': 'person',
      'color': 0xFF87CEEB,
    },
    {
      'title': 'Business Loan',
      'description': 'Grow your business with our flexible loans',
      'minAmount': 20000,
      'maxAmount': 500000,
      'interestRate': '12%',
      'maxTerm': '60 months',
      'icon': 'business',
      'color': 0xFF50C878,
    },
    {
      'title': 'Emergency Loan',
      'description': 'Fast cash for unexpected expenses',
      'minAmount': 5000,
      'maxAmount': 50000,
      'interestRate': '18%',
      'maxTerm': '12 months',
      'icon': 'emergency',
      'color': 0xFFFF9800,
    },
    {
      'title': 'Education Loan',
      'description': 'Invest in your future with education loans',
      'minAmount': 10000,
      'maxAmount': 200000,
      'interestRate': '10%',
      'maxTerm': '48 months',
      'icon': 'school',
      'color': 0xFF9C27B0,
    },
  ];
}
