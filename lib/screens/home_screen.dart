import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loan_app/l10n/app_localizations.dart';
import 'package:loan_app/screens/language_screen.dart' show LanguageScreen;
import '../../utils/constants.dart';
import '../../widgets/service_card.dart';
import 'loan_request_screen.dart';
import 'loan_calculator_screen.dart';
import 'about_screen.dart';
import 'contact_screen.dart';
import 'loan_products_screen.dart';
import 'faq_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

 @override
Widget build(BuildContext context) {
  // Add this import at the TOP of home_screen.dart if missing:
  // import 'package:loan_app/l10n/app_localizations.dart';

  final l10n = AppLocalizations.of(context)!; // Add this line

  return Scaffold(
    // ✅ ADD THIS APPBAR TO SHOW THE HAMBURGER MENU
    appBar: AppBar(
      title: Text(l10n.appName),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      automaticallyImplyLeading: true, // Ensures drawer icon appears
    ),

    drawer: _buildDrawer(context),
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          _buildActionButtons(context),
          _buildServices(context),
          _buildQuickStats(),
          _buildFooter(context),
        ],
      ),
    ),
  );
}

 Widget _buildHeader(BuildContext context) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      // Apply the same beautiful gradient as Splash & About Screen
      gradient: LinearGradient(
        colors: [AppColors.primary, AppColors.secondary],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
    ),
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        // Logo - Increased size + centered
        Center(
          child: Image.asset(
            'assets/images/company_logo.png',
            width: 120,  // Increased from 80 → much more visible
            height: 120,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 15),

        // Company Name - Bold White
        Text(
          AppStrings.companyName,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,           // High contrast against gradient
                fontWeight: FontWeight.bold,
                shadows: [                      // Optional: subtle drop shadow for extra readability
                  Shadow(
                    blurRadius: 2.0,
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),

        // Tagline - Slightly lighter white
        Text(
          AppStrings.tagline,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white70,         // Slightly transparent white for hierarchy
                fontWeight: FontWeight.w500,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 5),

        // Motto - Italic, even lighter
        Text(
          AppStrings.motto,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white54,         // Even lighter for subtlety
                fontStyle: FontStyle.italic,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
// Add this as a new method in HomeScreen
  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoanRequestScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.send),
              label: const Text('Apply for Loan'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoanCalculatorScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.calculate),
              label: const Text('Calculator'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                side: BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServices(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Services',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 15),
          ServiceCard(
            icon: FontAwesomeIcons.userTie,
            title: 'Personal Loans',
            description: 'Quick personal loans up to \ETB 50,000',
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoanProductsScreen(),
                ),
              );
            },
          ),
          ServiceCard(
            icon: FontAwesomeIcons.briefcase,
            title: 'Business Loans',
            description: 'Grow your business with our flexible loans',
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoanProductsScreen(),
                ),
              );
            },
          ),
          ServiceCard(
            icon: FontAwesomeIcons.bolt,
            title: 'Emergency Loans',
            description: 'Fast cash for unexpected expenses',
            color: Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoanProductsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('10K+', 'Happy Customers'),
          _buildStatItem('24hr', 'Quick Approval'),
          _buildStatItem('4.8★', 'Rating'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textLight,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
            child: const Text('About Us'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactScreen()),
              );
            },
            child: const Text('Contact'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FAQScreen()),
              );
            },
            child: const Text('FAQs'),
          ),
        ],
      ),
    );
  }
  

   Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.primary,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/company_logo.png', // <--- Your logo here
                  width: 80, // Adjust size as needed
                  height: 80, // Adjust size as needed
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                Text(
                  AppStrings.appName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.request_page),
            title: const Text('Apply for Loan'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoanRequestScreen(),
                ),
              );
            },
          ),
          ListTile(
  leading: const Icon(Icons.language),
  title: const Text('Language'),
  onTap: () {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LanguageScreen()),
    );
  },
),
          ListTile(
            leading: const Icon(Icons.calculate),
            title: const Text('Loan Calculator'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoanCalculatorScreen(),
                ),
              );
            },
          ),
          // Add more menu items as needed
        ],
      ),
    );
  }
}
