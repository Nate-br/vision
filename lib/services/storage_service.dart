// lib/services/storage_service.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/loan_application.dart';

class StorageService {
  static const String _pendingLoanKey = 'pending_loan_application';

  /// Save a pending loan application
  static Future<bool> savePendingLoan(LoanApplication application) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(application.toJson());
      return await prefs.setString(_pendingLoanKey, jsonString);
    } catch (e) {
      print('Error saving pending loan: $e');
      return false;
    }
  }

  /// Get the current pending loan application
  static Future<LoanApplication?> getPendingLoan() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_pendingLoanKey);
      
      if (jsonString == null) return null;
      
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return LoanApplication.fromJson(jsonMap);
    } catch (e) {
      print('Error loading pending loan: $e');
      return null;
    }
  }

  /// Check if there's a pending loan application
  static Future<bool> hasPendingLoan() async {
    final loan = await getPendingLoan();
    return loan != null && loan.status == 'pending';
  }

  /// Delete the pending loan application
  static Future<bool> deletePendingLoan() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_pendingLoanKey);
    } catch (e) {
      print('Error deleting pending loan: $e');
      return false;
    }
  }

  /// Update loan status
  static Future<bool> updateLoanStatus(String status) async {
    try {
      final loan = await getPendingLoan();
      if (loan == null) return false;
      
      final updatedLoan = loan.copyWith(status: status);
      return await savePendingLoan(updatedLoan);
    } catch (e) {
      print('Error updating loan status: $e');
      return false;
    }
  }
}