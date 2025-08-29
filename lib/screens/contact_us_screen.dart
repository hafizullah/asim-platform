import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/localization/app_localizations.dart';
import '../core/widgets/sim_svg_logo.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    
    return _buildMaterialLayout(context, localization);
  }

  Widget _buildMaterialLayout(BuildContext context, AppLocalizations localization) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern App Bar with hero section
          SliverAppBar(
            expandedHeight: 260, // Reduced from 280 to 260
            floating: false,
            pinned: true,
            backgroundColor: colorScheme.primary,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: colorScheme.onPrimary),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary,
                      colorScheme.secondary,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50), // Reduced from 60 to 50
                      Hero(
                        tag: 'sim_logo',
                        child: SimSvgLogo.large(),
                      ),
                      const SizedBox(height: 20), // Reduced from 24 to 20
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: colorScheme.onPrimary.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('📧', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 8),
                            Text(
                              'Contact Us',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12), // Reduced from 16 to 12
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Get in Touch with sim.af eSIM',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Contact Information Section
          _buildContactInfoSection(context, localization),
          
          // Support Hours Section
          _buildSupportHoursSection(context, localization),
          
          // Quick Help Section
          _buildQuickHelpSection(context, localization),
          
          // FAQ Section
          _buildFAQSection(context, localization),
          
          // Footer
          _buildFooterSection(context, localization),
        ],
      ),
    );
  }

  Widget _buildContactInfoSection(BuildContext context, AppLocalizations localization) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.mail,
                    color: colorScheme.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Email Support',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'For assistance with your eSIM plans, technical support, or general inquiries, please reach out to us:',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.8),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            
            // Email Card
            InkWell(
              onTap: () => _launchEmail('info@sim.af'),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.email,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'info@asim.af',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap to send email',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: colorScheme.primary,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportHoursSection(BuildContext context, AppLocalizations localization) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primaryContainer,
              colorScheme.secondaryContainer,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '⏰',
                  style: TextStyle(fontSize: 32),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Support Hours',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'We strive to respond to all emails within 24 hours',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onPrimaryContainer.withOpacity(0.9),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Monday - Sunday: 24/7 Email Support',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickHelpSection(BuildContext context, AppLocalizations localization) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Help Topics',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'When contacting us, please include relevant details to help us assist you faster:',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            _buildHelpTopicCard(
              context: context,
              icon: Icons.settings,
              title: 'eSIM Setup & Activation',
              description: 'Help with QR code scanning, APN settings, and activation issues',
              topics: [
                'QR code not scanning',
                'eSIM activation problems',
                'Data connection issues',
                'APN configuration help',
              ],
            ),
            const SizedBox(height: 16),
            _buildHelpTopicCard(
              context: context,
              icon: Icons.payment,
              title: 'Purchase & Billing',
              description: 'Questions about plans, payments, and billing',
              topics: [
                'Plan selection guidance',
                'Payment methods',
                'Refund requests',
                'Invoice questions',
              ],
            ),
            const SizedBox(height: 16),
            _buildHelpTopicCard(
              context: context,
              icon: Icons.travel_explore,
              title: 'Travel Support',
              description: 'Assistance for travelers using eSIM in Afghanistan',
              topics: [
                'Coverage area questions',
                'Roaming information',
                'Data speed expectations',
                'Travel tips for connectivity',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpTopicCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required List<String> topics,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: topics.map((topic) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                topic,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection(BuildContext context, AppLocalizations localization) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(
              Icons.help_outline,
              color: colorScheme.primary,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Frequently Asked Questions',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Before contacting us, you might find your answer in our most common questions:',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.8),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildFAQItem(
              context: context,
              question: 'How long does eSIM activation take?',
              answer: 'eSIM activation typically takes 2-5 minutes after purchase.',
            ),
            const SizedBox(height: 12),
            _buildFAQItem(
              context: context,
              question: 'Which devices support eSIM?',
              answer: 'Most modern smartphones including iPhone XS and newer, Google Pixel 3 and newer, Samsung Galaxy S20 and newer.',
            ),
            const SizedBox(height: 12),
            _buildFAQItem(
              context: context,
              question: 'Can I use my eSIM outside Afghanistan?',
              answer: 'Our Afghanistan eSIM plans are designed specifically for use within Afghanistan.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem({
    required BuildContext context,
    required String question,
    required String answer,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return ExpansionTile(
      title: Text(
        question,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            answer,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterSection(BuildContext context, AppLocalizations localization) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(24, 24, 24, 32), // Added bottom margin
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary,
              colorScheme.secondary,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Text('🚀', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              'Ready to Get Connected?',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Still have questions? Don\'t hesitate to reach out at info@asim.af',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onPrimary.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _launchEmail('info@asim.af'),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.onPrimary,
                      foregroundColor: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: const Icon(Icons.email),
                    label: const Text('Send Email'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.onPrimary,
                      side: BorderSide(color: colorScheme.onPrimary),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Browse Plans'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16), // Additional bottom padding
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    final subject = Uri.encodeComponent('eSIM Support Request');
    final body = Uri.encodeComponent('Hello Asim Team,\n\nI need help with:\n\n[Please describe your issue here]\n\nBest regards');
    final emailUri = Uri.parse('mailto:$email?subject=$subject&body=$body');
    
    try {
      if (!await launchUrl(emailUri)) {
        throw Exception('Could not launch email client');
      }
    } catch (e) {
      debugPrint('Error launching email: $e');
    }
  }
}
