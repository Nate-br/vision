// lib/services/telegram_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/loan_application.dart';

class TelegramService {
  // TODO: Replace with your actual values from @BotFather
  // ignore: unused_field
  static const String _botToken = '8382406212:AAHHMBzcwYiqLhltPErmrt4yCNE-TZnOp1o';
  static const String _chatId = '1773592241';
  
  static const String _apiUrl = 'https://api.telegram.org/bot8382406212:AAHHMBzcwYiqLhltPErmrt4yCNE-TZnOp1o';
  
  /// Sends a new loan application to Telegram
  static Future<bool> sendLoanRequest(LoanApplication application) async {
    try {
      final message = _formatNewApplicationMessage(application);
      
      final response = await http.post(
        Uri.parse('$_apiUrl/sendMessage'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'chat_id': _chatId,
          'text': message,
          'parse_mode': 'Markdown',
        }),
      );

      if (response.statusCode == 200) {
        print('✅ Loan application sent to Telegram successfully');
        return true;
      } else {
        print('❌ Telegram API error: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error sending to Telegram: $e');
      return false;
    }
  }
  
  /// Sends a cancellation notification to Telegram
  static Future<bool> sendCancellation(LoanApplication application) async {
    try {
      final message = _formatCancellationMessage(application);
      
      final response = await http.post(
        Uri.parse('$_apiUrl/sendMessage'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'chat_id': _chatId,
          'text': message,
          'parse_mode': 'Markdown',
        }),
      );

      if (response.statusCode == 200) {
        print('✅ Cancellation sent to Telegram successfully');
        return true;
      } else {
        print('❌ Telegram API error: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error sending cancellation to Telegram: $e');
      return false;
    }
  }
  
  /// Format new application message
  static String _formatNewApplicationMessage(LoanApplication data) {
    final timestamp = _formatDateTime(data.submittedAt);
    
    return '''
🔔 *NEW LOAN APPLICATION*

👤 *Applicant Details*
━━━━━━━━━━━━━━━━━━
📝 Name: ${data.name}
📞 Phone: ${data.phone}
📧 Email: ${data.email}

💰 *Loan Information*
━━━━━━━━━━━━━━━━━━
💵 Amount: ETB ${data.amount}
🎯 Purpose: ${data.purpose}
💼 Employment: ${data.employment}
📊 Monthly Income: ETB ${data.income}

📱 *Preferred Contact*
━━━━━━━━━━━━━━━━━━
${data.contactMethod}

🆔 Application ID: `${data.id}`
⏰ Submitted: $timestamp
''';
  }
  
  /// Format cancellation message
  static String _formatCancellationMessage(LoanApplication data) {
    final timestamp = _formatDateTime(DateTime.now());
    
    return '''
🚫 *LOAN APPLICATION CANCELLED*

👤 *Applicant*
━━━━━━━━━━━━━━━━━━
📝 Name: ${data.name}
📞 Phone: ${data.phone}

💰 *Original Request*
━━━━━━━━━━━━━━━━━━
💵 Amount: ETB ${data.amount}
🎯 Purpose: ${data.purpose}

🆔 Application ID: `${data.id}`
❌ Cancelled: $timestamp
⚠️ Reason: User requested cancellation
''';
  }
  
  /// Helper to format DateTime
  static String _formatDateTime(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }
}