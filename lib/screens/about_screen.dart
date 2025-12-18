import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // ... (existing properties)
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('About Us'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary.withOpacity(0.8),
                      AppColors.secondary.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Center(
                  // Replace the faded Icon with your faded logo
                  child: Image.asset(
                    'assets/images/company_logo.png', // <--- Your logo here
                    width: 100, // Adjust size
                    height: 100, // Adjust size
                    fit: BoxFit.contain,
                    // Apply a color filter to make it faded, similar to the original icon
                    color: Colors.white.withOpacity(0.3),
                    colorBlendMode: BlendMode.modulate,
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company Overview Card
                  _buildSectionCard(
                    context,
                    icon: Icons.business,
                    title: 'Who We Are',
                    content: AppStrings.companyName +
                        ' is a leading financial services provider in Ethiopia, '
                        'committed to making financial solutions accessible to everyone. '
                        'Since our establishment, we have been helping individuals and '
                        'businesses achieve their dreams through affordable loan services.',
                  ),
                  const SizedBox(height: 20),

                  // Vision Card
                  _buildSectionCard(
                    context,
                    icon: Icons.visibility,
                    title: 'Our Vision',
                    content:
                        'To be the most trusted and accessible financial partner '
                        'for every Ethiopian, enabling dreams and building futures '
                        'through innovative and responsible lending solutions.',
                  ),
                  const SizedBox(height: 20),

                  // Mission Card
                  _buildSectionCard(
                    context,
                    icon: Icons.flag,
                    title: 'Our Mission',
                    content:
                        'We strive to provide quick, transparent, and affordable '
                        'loan services while maintaining the highest standards of '
                        'customer service and financial responsibility.',
                  ),
                  const SizedBox(height: 20),

                  // Values Section
                  Text(
                    'Our Core Values',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                  ),
                  const SizedBox(height: 15),

                  _buildValueItem(
                    context,
                    'Integrity',
                    'We operate with complete transparency and honesty',
                    Icons.verified_user,
                  ),
                  _buildValueItem(
                    context,
                    'Excellence',
                    'We deliver exceptional service at every touchpoint',
                    Icons.star,
                  ),
                  _buildValueItem(
                    context,
                    'Innovation',
                    'We embrace technology to simplify lending',
                    Icons.lightbulb,
                  ),
                  _buildValueItem(
                    context,
                    'Empowerment',
                    'We enable our customers to achieve their goals',
                    Icons.rocket_launch,
                  ),

                  const SizedBox(height: 30),

                  // Statistics
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
                        Text(
                          'Our Impact',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem('10,000+', 'Happy Customers'),
                            _buildStatItem('500M+', 'ETB Disbursed'),
                            _buildStatItem('98%', 'Approval Rate'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Team Section
                  Text(
                    'Why Choose Us?',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                  ),
                  const SizedBox(height: 15),

                  _buildFeatureItem(
                    'Quick Approval',
                    'Get approved within 24 hours',
                    Icons.speed,
                  ),
                  _buildFeatureItem(
                    'Competitive Rates',
                    'Best interest rates in the market',
                    Icons.trending_down,
                  ),
                  _buildFeatureItem(
                    'Flexible Terms',
                    'Repayment plans that suit your needs',
                    Icons.date_range,
                  ),
                  _buildFeatureItem(
                    'No Hidden Fees',
                    'Transparent pricing with no surprises',
                    Icons.visibility,
                  ),

                  const SizedBox(height: 30),

                  // Contact CTA
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.accent.withOpacity(0.1),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.support_agent,
                            size: 50,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Need Help?',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Our team is here to help you',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(context, '/contact');
                            },
                            icon: const Icon(Icons.phone),
                            label: const Text('Contact Us'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
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
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: AppColors.primary),
                ),
                const SizedBox(width: 15),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: AppColors.textLight,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueItem(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textLight,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String title, String subtitle, IconData icon) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withOpacity(0.1),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
    );
  }
}