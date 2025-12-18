// lib/models/loan_application.dart

class LoanApplication {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String amount;
  final String purpose;
  final String employment;
  final String income;
  final String contactMethod;
  final DateTime submittedAt;
  final String status; // 'pending', 'approved', 'rejected', 'cancelled'

  LoanApplication({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.amount,
    required this.purpose,
    required this.employment,
    required this.income,
    required this.contactMethod,
    required this.submittedAt,
    this.status = 'pending',
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'amount': amount,
      'purpose': purpose,
      'employment': employment,
      'income': income,
      'contactMethod': contactMethod,
      'submittedAt': submittedAt.toIso8601String(),
      'status': status,
    };
  }

  // Create from JSON
  factory LoanApplication.fromJson(Map<String, dynamic> json) {
    return LoanApplication(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      amount: json['amount'] as String,
      purpose: json['purpose'] as String,
      employment: json['employment'] as String,
      income: json['income'] as String,
      contactMethod: json['contactMethod'] as String,
      submittedAt: DateTime.parse(json['submittedAt'] as String),
      status: json['status'] as String? ?? 'pending',
    );
  }

  // Create a copy with modified fields
  LoanApplication copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? amount,
    String? purpose,
    String? employment,
    String? income,
    String? contactMethod,
    DateTime? submittedAt,
    String? status,
  }) {
    return LoanApplication(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      amount: amount ?? this.amount,
      purpose: purpose ?? this.purpose,
      employment: employment ?? this.employment,
      income: income ?? this.income,
      contactMethod: contactMethod ?? this.contactMethod,
      submittedAt: submittedAt ?? this.submittedAt,
      status: status ?? this.status,
    );
  }
}