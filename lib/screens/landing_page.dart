import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import '../core/providers/language_provider.dart';
import '../core/localization/app_localizations.dart';
import '../core/services/esim_plan_service.dart';
import '../core/models/esim_plan.dart';
import '../core/widgets/asim_svg_logo.dart';
import 'webview_screen.dart';
import 'terms_conditions_screen.dart';
import 'about_us_screen.dart';
import 'contact_us_screen.dart';

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
      // Clear cache to ensure fresh data
      EsimPlanService.clearCache();
      print('DEBUG: Cache cleared, loading fresh plans...');
      
      // Load ALL Afghanistan plans instead of just featured ones
      final plans = await EsimPlanService.getAfghanistanPlans();
      print('DEBUG: Loaded ${plans.length} plans in landing page');
      
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
    
    // Always use Material Design for web compatibility
    // While Cupertino would work on iOS, Material provides better web support
    return _buildMaterialLayout(context, localization);
  }

  Widget _buildMaterialLayout(BuildContext context, AppLocalizations localization) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern App Bar with custom positioning
          SliverToBoxAdapter(
            child: Container(
              height: 56, // Standard app bar height
              color: colorScheme.surface,
              child: Stack(
                children: [
                  // Left side - Logo and title
                  Positioned(
                    left: 16,
                    top: 0,
                    bottom: 0,
                    child: Row(
                      children: [
                        AsimSvgLogo.small(),
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
                  ),
                  // Right side - Language buttons (always LTR positioned)
                  Positioned(
                    right: 16,
                    top: 0,
                    bottom: 0,
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Center(
                        child: Consumer<LanguageProvider>(
                          builder: (context, languageProvider, child) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildLanguageButton(
                                  context: context,
                                  languageCode: 'en',
                                  languageLabel: localization.english,
                                  isSelected: languageProvider.locale.languageCode == 'en',
                                  onPressed: () => languageProvider.setLanguage('en'),
                                  colorScheme: colorScheme,
                                ),
                                const SizedBox(width: 4),
                                _buildLanguageButton(
                                  context: context,
                                  languageCode: 'fa',
                                  languageLabel: localization.dari,
                                  isSelected: languageProvider.locale.languageCode == 'fa',
                                  onPressed: () => languageProvider.setLanguage('fa'),
                                  colorScheme: colorScheme,
                                ),
                                const SizedBox(width: 4),
                                _buildLanguageButton(
                                  context: context,
                                  languageCode: 'ps',
                                  languageLabel: localization.pashto,
                                  isSelected: languageProvider.locale.languageCode == 'ps',
                                  onPressed: () => languageProvider.setLanguage('ps'),
                                  colorScheme: colorScheme,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          _buildMaterialHeroSection(context, localization),
          _buildMaterialPlansSection(context, localization),
          _buildMaterialOtherCountriesSection(context, localization),
          _buildMaterialFeaturesSection(context, localization),
          _buildMaterialContactSection(context, localization),
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
      '${plan.dataAmount} ${localization.afghanistanDataFeatures} ${plan.duration}',
      localization.afghanistanCoverage,
      localization.instantActivation,
      localization.support24x7,
      if (plan.name.contains('GB')) localization.highSpeedData,
    ];

    return Container(
      width: double.infinity, // Full width instead of fixed 280
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
                  '🇦🇫 ${plan.dataAmount} ${localization.afghanistan}',
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
                const SizedBox(height: 20),
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
    final localization = AppLocalizations.of(context);
    try {
      // For web platform, always use external browser due to WebView limitations
      if (kIsWeb) {
        final Uri uri = Uri.parse(url);
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          throw Exception('Could not launch $url');
        }
      } else {
        // Use in-app WebView for mobile platforms
        if (url.contains('esimqr.link') || url.contains('payment') || url.contains('buy')) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WebViewScreen(
                url: url,
                title: localization.purchaseEsim,
              ),
            ),
          );
        } else {
          // Use external browser for other links
          final Uri uri = Uri.parse(url);
          if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
            throw Exception('Could not launch $url');
          }
        }
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      // Show a snackbar with error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open link: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildLanguageButton({
    required BuildContext context,
    required String languageCode,
    required String languageLabel,
    required bool isSelected,
    required VoidCallback onPressed,
    required ColorScheme colorScheme,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 65, // Increased width to accommodate "English" text
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? colorScheme.primary : colorScheme.outline,
              width: 1,
            ),
          ),
          child: Text(
            languageLabel,
            style: TextStyle(
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center, // Center the text within the fixed width
            maxLines: 1, // Ensure single line
            overflow: TextOverflow.ellipsis, // Handle overflow gracefully
          ),
        ),
      ),
    );
  }

  void _showLanguageSelector(BuildContext context, LanguageProvider languageProvider, AppLocalizations localization) {
    // Always use Material design for web compatibility
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(localization.selectLanguage),
              onTap: null,
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(localization.english),
              onTap: () {
                languageProvider.setLanguage('en');
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(localization.dari),
              onTap: () {
                languageProvider.setLanguage('fa');
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(localization.pashto),
              onTap: () {
                languageProvider.setLanguage('ps');
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Cupertino Sections
  Widget _buildCupertinoHeroSection(BuildContext context, AppLocalizations localization) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE8F5E8),
              Color(0xFFF1F8E9),
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Icon(
              CupertinoIcons.globe,
              size: 80,
              color: Color(0xFF2E7D32),
            ),
            const SizedBox(height: 32),
            
            // First Customer Scenario - Travelers
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground.resolveFrom(context).withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Icon(
                    CupertinoIcons.airplane,
                    size: 32,
                    color: Color(0xFF2E7D32),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    localization.flyingToAfghanistan,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localization.flyingToAfghanistanDesc,
                    style: TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Second Customer Scenario - Family Helper
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground.resolveFrom(context).withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Icon(
                    CupertinoIcons.person_3_fill,
                    size: 32,
                    color: Color(0xFF2E7D32),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    localization.haveFamilyInAfghanistan,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localization.haveFamilyInAfghanistanDesc,
                    style: TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Call to Action pointing to plans below
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.chevron_down,
                    color: Color(0xFF2E7D32),
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    localization.chooseYourPerfectPlan,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    CupertinoIcons.chevron_down,
                    color: Color(0xFF2E7D32),
                    size: 24,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCupertinoPlansSection(BuildContext context, AppLocalizations localization) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localization.afghanistanEsimPlans,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              localization.reliableAfghanistanPlans,
              style: TextStyle(
                fontSize: 16,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const Center(child: CupertinoActivityIndicator())
                : _afghanistanPlans.isEmpty
                    ? Center(
                        child: Text(
                          localization.noPlansAvailable,
                          style: const TextStyle(fontSize: 16),
                        ),
                      )
                    : Column(
                        children: _afghanistanPlans.map((plan) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildCupertinoPlanCard(
                              context: context, 
                              plan: plan, 
                              localization: localization,
                            ),
                          );
                        }).toList(),
                      ),
          ],
        ),
      ),
    );
  }

  Widget _buildCupertinoFeaturesSection(BuildContext context, AppLocalizations localization) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localization.features,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildCupertinoFeatureItem(
              context: context,
              icon: CupertinoIcons.bolt_fill,
              title: localization.instantActivation,
              description: localization.instantActivationDesc,
            ),
            const SizedBox(height: 16),
            _buildCupertinoFeatureItem(
              context: context,
              icon: CupertinoIcons.location_fill,
              title: localization.afghanistanCoverage,
              description: localization.afghanistanCoverageDesc,
            ),
            const SizedBox(height: 16),
            _buildCupertinoFeatureItem(
              context: context,
              icon: CupertinoIcons.money_dollar_circle_fill,
              title: localization.affordablePrices,
              description: localization.competitiveAfghanistanRates,
            ),
            const SizedBox(height: 16),
            _buildCupertinoFeatureItem(
              context: context,
              icon: CupertinoIcons.checkmark_shield_fill,
              title: localization.noContracts,
              description: localization.noContractsDesc,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCupertinoContactSection(BuildContext context, AppLocalizations localization) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground.resolveFrom(context),
          border: Border(
            top: BorderSide(
              color: CupertinoColors.separator.resolveFrom(context),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCupertinoFooterLink(
              context: context,
              text: localization.termsAndConditions,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TermsConditionsScreen(),
                  ),
                );
              },
            ),
            _buildCupertinoFooterDivider(context),
            _buildCupertinoFooterLink(
              context: context,
              text: localization.about,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AboutUsScreen(),
                  ),
                );
              },
            ),
            _buildCupertinoFooterDivider(context),
            _buildCupertinoFooterLink(
              context: context,
              text: localization.contact,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ContactUsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCupertinoFooterLink({
    required BuildContext context,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: CupertinoColors.systemBlue.resolveFrom(context),
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _buildCupertinoFooterDivider(BuildContext context) {
    return Container(
      width: 1,
      height: 16,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: CupertinoColors.separator.resolveFrom(context),
    );
  }

  // Material Sections
  Widget _buildMaterialHeroSection(BuildContext context, AppLocalizations localization) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return SliverToBoxAdapter(
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
            AsimSvgLogo.large(),
            const SizedBox(height: 32),
            
            // First Customer Scenario - Travelers
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: colorScheme.surface.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.flight_takeoff,
                    size: 32,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    localization.flyingToAfghanistan,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localization.flyingToAfghanistanDesc,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Second Customer Scenario - Family Helper
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: colorScheme.surface.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.family_restroom,
                    size: 32,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    localization.haveFamilyInAfghanistan,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localization.haveFamilyInAfghanistanDesc,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Call to Action pointing to plans below
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.primary.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    localization.chooseYourPerfectPlan,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialPlansSection(BuildContext context, AppLocalizations localization) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localization.afghanistanEsimPlans,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              localization.reliableAfghanistanPlans,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _afghanistanPlans.isEmpty
                    ? Center(
                        child: Text(
                          localization.noPlansAvailable,
                          style: theme.textTheme.bodyLarge,
                        ),
                      )
                    : Column(
                        children: _afghanistanPlans.map((plan) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildAfghanistanPlanCard(
                              context: context,
                              plan: plan,
                            ),
                          );
                        }).toList(),
                      ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialFeaturesSection(BuildContext context, AppLocalizations localization) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return SliverToBoxAdapter(
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
              title: localization.afghanistanCoverage,
              description: localization.afghanistanCoverageDesc,
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              context: context,
              icon: Icons.attach_money,
              title: localization.affordablePrices,
              description: localization.competitiveAfghanistanRates,
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
    );
  }

  Widget _buildMaterialContactSection(BuildContext context, AppLocalizations localization) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFooterLink(
              context: context,
              text: localization.termsAndConditions,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TermsConditionsScreen(),
                  ),
                );
              },
            ),
            _buildFooterDivider(colorScheme),
            _buildFooterLink(
              context: context,
              text: localization.about,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AboutUsScreen(),
                  ),
                );
              },
            ),
            _buildFooterDivider(colorScheme),
            _buildFooterLink(
              context: context,
              text: localization.contact,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ContactUsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterLink({
    required BuildContext context,
    required String text,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.primary,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _buildFooterDivider(ColorScheme colorScheme) {
    return Container(
      width: 1,
      height: 16,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: colorScheme.outline.withOpacity(0.3),
    );
  }

  Widget _buildCupertinoPlanCard({
    required BuildContext context,
    required EsimPlan plan,
    required AppLocalizations localization,
  }) {
    // Generate features for Afghanistan plans
    final features = <String>[
      '${plan.dataAmount} ${localization.afghanistanDataFeatures} ${plan.duration}',
      localization.afghanistanCoverage,
      localization.instantActivation,
      localization.support24x7,
      if (plan.name.contains('GB')) localization.highSpeedData,
    ];

    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(12),
        border: plan.isPopular
            ? Border.all(color: const Color(0xFF2E7D32), width: 2)
            : Border.all(color: CupertinoColors.separator.resolveFrom(context)),
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
                    color: const Color(0xFF2E7D32),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    localization.popular,
                    style: const TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (plan.isPopular) const SizedBox(height: 12),
              Text(
                '🇦🇫 ${plan.dataAmount} ${localization.afghanistan}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    plan.formattedPrice,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  if (plan.duration.isNotEmpty)
                    Text(
                      ' / ${plan.duration}',
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              ...features.take(5).map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(
                      CupertinoIcons.checkmark_circle_fill,
                      size: 16,
                      color: Color(0xFF2E7D32),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: () => _launchURL(plan.directLink),
                  child: Text(localization.buyNow),
                ),
              ),
            ],
          ),
        ),
    );
  }

  Widget _buildCupertinoFeatureItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF2E7D32),
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialOtherCountriesSection(BuildContext context, AppLocalizations localization) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              Icons.public,
              size: 48,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              localization.needEsimOtherCountries,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              localization.otherCountriesDescription,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _launchURL('https://asim.esimqr.link/'),
                icon: const Icon(Icons.explore),
                label: Text(localization.browseAllCountries),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
