import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/providers/language_provider.dart';
import '../core/localization/app_localizations.dart';
import '../core/services/esim_plan_service.dart';
import '../core/models/esim_plan.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  List<EsimPlan> _afghanistanPlans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAfghanistanPlans();
  }

  Future<void> _loadAfghanistanPlans() async {
    try {
      final plans = await EsimPlanService.getFeaturedAfghanistanPlans();
      if (mounted) {
        setState(() {
          _afghanistanPlans = plans;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      debugPrint('Error loading Afghanistan plans: $e');
    }
  }

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
                    'Stay Connected in Afghanistan',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Get instant eSIM data plans for Afghanistan. No physical SIM required.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: () {
                      if (_afghanistanPlans.isNotEmpty) {
                        _launchURL(_afghanistanPlans.first.directLink);
                      } else {
                        _launchURL('https://asim.esimqr.link/');
                      }
                    },
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
                    'Afghanistan eSIM Plans',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Stay connected in Afghanistan with our reliable data plans',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Horizontal scrollable plans
                  SizedBox(
                    height: 380,
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _afghanistanPlans.isEmpty
                            ? Center(
                                child: Text(
                                  'No plans available',
                                  style: theme.textTheme.bodyLarge,
                                ),
                              )
                            : ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: _afghanistanPlans.length,
                                separatorBuilder: (context, index) => const SizedBox(width: 16),
                                itemBuilder: (context, index) {
                                  final plan = _afghanistanPlans[index];
                                  return _buildAfghanistanPlanCard(
                                    context: context,
                                    plan: plan,
                                  );
                                },
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
                    icon: Icons.location_on,
                    title: 'Afghanistan Coverage',
                    description: 'Reliable network coverage across Afghanistan',
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    context: context,
                    icon: Icons.attach_money,
                    title: localization.affordablePrices,
                    description: 'Competitive rates for Afghanistan data plans',
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
                    'Ready to stay connected in Afghanistan?',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Choose your Afghanistan eSIM plan and stay connected anywhere in the country.',
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
                        onPressed: () {
                          if (_afghanistanPlans.isNotEmpty) {
                            _launchURL(_afghanistanPlans.first.directLink);
                          } else {
                            _launchURL('https://asim.esimqr.link/');
                          }
                        },
                        icon: const Icon(Icons.shopping_cart),
                        label: Text(localization.buyNow),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _launchURL('https://asim.esimqr.link/'),
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

  Widget _buildAfghanistanPlanCard({
    required BuildContext context,
    required EsimPlan plan,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = AppLocalizations.of(context);

    // Generate features for Afghanistan plans
    final features = <String>[
      '${plan.dataAmount} data ${plan.duration}',
      'Afghanistan coverage',
      'Instant activation',
      '24/7 support',
      if (plan.name.contains('GB')) 'High-speed data',
    ];

    return Container(
      width: 280,
      child: Card(
        elevation: plan.isPopular ? 8 : 2,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: plan.isPopular
                ? Border.all(color: colorScheme.primary, width: 2)
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (plan.isPopular)
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
                if (plan.isPopular) const SizedBox(height: 12),
                Text(
                  '${plan.dataAmount} Afghanistan',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      plan.formattedPrice,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    if (plan.duration.isNotEmpty)
                      Text(
                        ' / ${plan.duration}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                ...features.take(5).map((feature) => Padding(
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
                    onPressed: () => _launchURL(plan.directLink),
                    style: FilledButton.styleFrom(
                      backgroundColor: plan.isPopular ? colorScheme.primary : null,
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
