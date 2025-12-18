// lib/screens/language_screen.dart
import 'package:flutter/material.dart';
import 'package:loan_app/l10n/app_localizations.dart';
import 'package:loan_app/main.dart';  // Import to access MyApp.changeLocale
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart' show AppColors;

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguageCode = 'en';

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('languageCode') ?? 'en';
    setState(() {
      _selectedLanguageCode = code;
    });
  }

  Future<void> _changeLanguage(String languageCode) async {
    final locale = Locale(languageCode);
    
    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);

    // Update app locale
    MyApp.changeLocale(locale);  // This triggers rebuild with new language

    setState(() {
      _selectedLanguageCode = languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.language),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.selectLanguage,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            _buildLanguageTile('English', 'en', '🇺🇸'),
            _buildLanguageTile('አማርኛ', 'am', '🇪🇹'),
            _buildLanguageTile('Afaan Oromoo', 'or', '🇪🇹'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageTile(String name, String code, String flag) {
    final isSelected = _selectedLanguageCode == code;
    return Card(
      elevation: isSelected ? 8 : 2,
      color: isSelected ? AppColors.primary.withOpacity(0.1) : null,
      child: ListTile(
        leading: Text(flag, style: const TextStyle(fontSize: 30)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: isSelected ? Icon(Icons.check_circle, color: AppColors.primary) : null,
        onTap: () => _changeLanguage(code),
      ),
    );
  }
}