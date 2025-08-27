import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/providers/language_provider.dart';
import '../core/localization/app_localizations.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            backgroundColor: colorScheme.surface,
            elevation: 0,
            title: Row(
              children: [
                Icon(
                  Icons.signal_cellular_4_bar,
                  color: colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  localization.appName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            actions: [
              Consumer<LanguageProvider>(
                builder: (context, languageProvider, child) {
                  return PopupMenuButton<String>(
                    icon: Icon(
                      Icons.language,
                      color: colorScheme.primary,
                    ),
                    onSelected: (String languageCode) {
                      languageProvider.setLanguage(languageCode);
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        value: 'en',
                        child: Text(localization.english),
                      ),
                      PopupMenuItem(
                        value: 'fa',
                        child: Text(localization.dari),
                      ),
                      PopupMenuItem(
                        value: 'ps',
                        child: Text(localization.pashto),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),

          // Hero Section
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primaryContainer,
                    colorScheme.secondaryContainer,
                  ],
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Icon(
                    Icons.public,
                    size: 80,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    localization.welcomeTitle,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    localization.welcomeSubtitle,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: () => _launchURL('https://example.com/purchase'),
                    icon: const Icon(Icons.shopping_cart),
                    label: Text(localization.getStarted),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // Plans Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localization.chooseYourPlan,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localization.planDescription,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Horizontal scrollable plans
                  SizedBox(
                    height: 350,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildPlanCard(
                          context: context,
                          title: '5GB Starter',
                          price: '\$15',
                          duration: '7 days',
                          features: [
                            '5GB high-speed data',
                            '190+ countries',
                            'Instant activation',
                            '24/7 support'
                          ],
                          isPopular: false,
                          purchaseUrl: 'https://example.com/purchase/starter',
                        ),
                        const SizedBox(width: 16),
                        _buildPlanCard(
                          context: context,
                          title: '15GB Explorer',
                          price: '\$35',
                          duration: '30 days',
                          features: [
                            '15GB high-speed data',
                            '190+ countries',
                            'Instant activation',
                            '24/7 support',
                            'Hotspot sharing'
                          ],
                          isPopular: true,
                          purchaseUrl: 'https://example.com/purchase/explorer',
                        ),
                        const SizedBox(width: 16),
                        _buildPlanCard(
                          context: context,
                          title: '50GB Business',
                          price: '\$89',
                          duration: '30 days',
                          features: [
                            '50GB high-speed data',
                            '190+ countries',
                            'Instant activation',
                            'Priority support',
                            'Hotspot sharing',
                            'Multi-device support'
                          ],
                          isPopular: false,
                          purchaseUrl: 'https://example.com/purchase/business',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Features Section
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localization.features,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildFeatureItem(
                    context: context,
                    icon: Icons.flash_on,
                    title: localization.instantActivation,
                    description: localization.instantActivationDesc,
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    context: context,
                    icon: Icons.public,
                    title: localization.globalCoverage,
                    description: localization.globalCoverageDesc,
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    context: context,
                    icon: Icons.attach_money,
                    title: localization.affordablePrices,
                    description: localization.affordablePricesDesc,
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    context: context,
                    icon: Icons.no_accounts,
                    title: localization.noContracts,
                    description: localization.noContractsDesc,
                  ),
                ],
              ),
            ),
          ),

          // Contact Section
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    'Ready to get started?',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Choose your plan and stay connected anywhere in the world.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      FilledButton.icon(
                        onPressed: () => _launchURL('https://example.com/purchase'),
                        icon: const Icon(Icons.shopping_cart),
                        label: Text(localization.buyNow),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _launchURL('https://example.com/support'),
                        icon: const Icon(Icons.support_agent),
                        label: Text(localization.contact),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required BuildContext context,
    required String title,
    required String price,
    required String duration,
    required List<String> features,
    required bool isPopular,
    required String purchaseUrl,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = AppLocalizations.of(context);

    return Container(
      width: 280,
      child: Card(
        elevation: isPopular ? 8 : 2,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isPopular
                ? Border.all(color: colorScheme.primary, width: 2)
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isPopular)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      localization.popular,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (isPopular) const SizedBox(height: 12),
                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    Text(
                      ' / $duration',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ...features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 16,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                )),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => _launchURL(purchaseUrl),
                    style: FilledButton.styleFrom(
                      backgroundColor: isPopular ? colorScheme.primary : null,
                    ),
                    child: Text(localization.buyNow),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: colorScheme.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }
}
