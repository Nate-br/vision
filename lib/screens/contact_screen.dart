import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:maps_launcher/maps_launcher.dart';
import '../../utils/constants.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  void _launchPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: AppStrings.phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  void _launchEmail() async {
    final Uri emailUri = Uri(scheme: 'mailto', path: AppStrings.email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _launchWhatsApp() async {
    final Uri whatsappUri = Uri.parse('https://wa.me/251911234567');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    }
  }

  void _launchMaps() async {
    MapsLauncher.launchQuery('Mehal Adama MKC, Addis Ababa, Ethiopia');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Contact Us'),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.headset_mic,
                        size: 60,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'We\'re Here to Help',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                    ],
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
                  // Quick Contact Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickContactCard(
                          context,
                          icon: Icons.phone,
                          label: 'Call Us',
                          color: AppColors.primary,
                          onTap: _launchPhone,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildQuickContactCard(
                          context,
                          icon: Icons.email,
                          label: 'Email Us',
                          color: AppColors.secondary,
                          onTap: _launchEmail,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickContactCard(
                          context,
                          icon: Icons.chat,
                          label: 'WhatsApp',
                          color: Colors.green,
                          onTap: _launchWhatsApp,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildQuickContactCard(
                          context,
                          icon: Icons.location_on,
                          label: 'Visit Us',
                          color: Colors.orange,
                          onTap: _launchMaps,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Office Information Card
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.business,
                                color: AppColors.primary,
                                size: 30,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Head Office',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildInfoRow(
                            Icons.location_on_outlined,
                            'Address',
                            AppStrings.address,
                          ),
                          const Divider(height: 30),
                          _buildInfoRow(
                            Icons.phone_outlined,
                            'Phone',
                            AppStrings.phone,
                          ),
                          const Divider(height: 30),
                          _buildInfoRow(
                            Icons.email_outlined,
                            'Email',
                            AppStrings.email,
                          ),
                          const Divider(height: 30),
                          _buildInfoRow(
                            Icons.access_time_outlined,
                            'Working Hours',
                            AppStrings.workingHours,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Map Preview Card
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: _launchMaps,
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary.withOpacity(0.3),
                              AppColors.secondary.withOpacity(0.3),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.map,
                              size: 60,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Tap to Open in Maps',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Mehal Adama MKC',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Social Media Section
                  Text(
                    'Connect With Us',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSocialButton(
                        Icons.facebook,
                        'Facebook',
                        const Color(0xFF1877F2),
                        () {},
                      ),
                      _buildSocialButton(
                        Icons.telegram,
                        'Telegram',
                        const Color(0xFF0088CC),
                        () {},
                      ),
                      _buildSocialButton(
                        Icons.camera_alt,
                        'Instagram',
                        const Color(0xFFE4405F),
                        () {},
                      ),
                      _buildSocialButton(
                        Icons.linked_camera,
                        'LinkedIn',
                        const Color(0xFF0077B5),
                        () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // FAQ CTA
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: AppColors.accent.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.help_outline,
                          size: 40,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Have Questions?',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Check our frequently asked questions',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/faq');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                          ),
                          child: const Text('View FAQs'),
                        ),
                      ],
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

  Widget _buildQuickContactCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}