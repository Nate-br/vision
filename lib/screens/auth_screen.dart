import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pinput/pinput.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final storage = const FlutterSecureStorage();
  final phoneController = TextEditingController();
  final baseUrl = "https://your-vercel-app.vercel.app/api";

  int step = 1; // 1: Phone, 2: OTP, 3: Set/Enter PIN
  bool isLoading = false;

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> checkPhone() async {
    setState(() => isLoading = true);
    final res = await http.post(Uri.parse("$baseUrl/auth/check-phone"),
        body: jsonEncode({"phone": "251${phoneController.text}"}),
        headers: {"Content-Type": "application/json"});

    setState(() => isLoading = false);
    if (res.statusCode == 200) {
      setState(() => step = 2);
    } else {
      _showMessage("Phone not registered. Please sign up in @VisionsLoansBot");
    }
  }

  Future<void> verifyOtp(String otp) async {
    setState(() => isLoading = true);
    final res = await http.post(Uri.parse("$baseUrl/auth/verify-otp"),
        body: jsonEncode({"phone": "251${phoneController.text}", "otp": otp}),
        headers: {"Content-Type": "application/json"});

    setState(() => isLoading = false);
    if (res.statusCode == 200) {
      await storage.write(key: "phone", value: "251${phoneController.text}");
      setState(() => step = 3);
    } else {
      _showMessage("Invalid OTP");
    }
  }

  Future<void> loginPin(String pin) async {
    setState(() => isLoading = true);
    final res = await http.post(Uri.parse("$baseUrl/auth/login-pin"),
        body: jsonEncode({"phone": "251${phoneController.text}", "pin": pin}),
        headers: {"Content-Type": "application/json"});

    setState(() => isLoading = false);
    if (res.statusCode == 200) {
      await storage.write(key: "isLoggedIn", value: "true");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } else {
      _showMessage("Incorrect PIN");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Vision for a better life")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (step == 1) ...[
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(prefixText: "+251 ", labelText: "Phone Number"),
              ),
              ElevatedButton(onPressed: checkPhone, child: Text("Send OTP"))
            ],
            if (step == 2) ...[
              Text("Enter 6-digit OTP sent to Telegram"),
              Pinput(length: 6, onCompleted: verifyOtp),
            ],
            if (step == 3) ...[
              Text("Enter your 4-digit PIN"),
              Pinput(length: 4, onCompleted: loginPin),
            ],
            if (isLoading) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}