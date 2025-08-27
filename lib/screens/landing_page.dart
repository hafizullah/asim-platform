import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../core/providers/language_provider.dart';
import '../core/localization/app_localizations.dart';
import '../core/services/esim_plan_service.dart';
import '../core/models/esim_plan.dart';
import 'webview_screen.dart';

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
      
      final plans = await EsimPlanService.getFeaturedAfghanistanPlans();
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
    
    if (Platform.isIOS) {
      return _buildCupertinoLayout(context, localization);
    } else {
      return _buildMaterialLayout(context, localization);
    }
  }

  Widget _buildCupertinoLayout(BuildContext context, AppLocalizations localization) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              CupertinoIcons.antenna_radiowaves_left_right,
              color: Color(0xFF2E7D32),
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(
              localization.appName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
          ],
        ),
        trailing: Consumer<LanguageProvider>(
          builder: (context, languageProvider, child) {
            return CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.globe),
              onPressed: () {
                _showLanguageSelector(context, languageProvider, localization);
              },
            );
          },
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildCupertinoHeroSection(context, localization),
            _buildCupertinoPlansSection(context, localization),
            _buildCupertinoFeaturesSection(context, localization),
            _buildCupertinoContactSection(context, localization),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialLayout(BuildContext context, AppLocalizations localization) {
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

          _buildMaterialHeroSection(context, localization),
          _buildMaterialPlansSection(context, localization),
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
    final localization = AppLocalizations.of(context);
    try {
      // Use in-app WebView for purchase links
      if (url.contains('esimqr.link') || url.contains('payment') || url.contains('buy')) {
        Navigator.of(context).push(
          Platform.isIOS
              ? CupertinoPageRoute(
                  builder: (context) => WebViewScreen(
                    url: url,
                    title: localization.purchaseEsim,
                  ),
                )
              : MaterialPageRoute(
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
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  void _showLanguageSelector(BuildContext context, LanguageProvider languageProvider, AppLocalizations localization) {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          title: Text(localization.selectLanguage),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                languageProvider.setLanguage('en');
                Navigator.pop(context);
              },
              child: Text(localization.english),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                languageProvider.setLanguage('fa');
                Navigator.pop(context);
              },
              child: Text(localization.dari),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                languageProvider.setLanguage('ps');
                Navigator.pop(context);
              },
              child: Text(localization.pashto),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: Text(localization.cancel),
          ),
        ),
      );
    }
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
            const SizedBox(height: 24),
            Text(
              localization.stayConnectedAfghanistan,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              localization.afghanistanDataPlans,
              style: TextStyle(
                fontSize: 16,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            CupertinoButton.filled(
              onPressed: () {
                if (_afghanistanPlans.isNotEmpty) {
                  _launchURL(_afghanistanPlans.first.directLink);
                } else {
                  _launchURL('https://asim.esimqr.link/');
                }
              },
              child: Text(localization.getStarted),
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
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              localization.readyStayConnectedAfghanistan,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              localization.chooseAfghanistanPlan,
              style: TextStyle(
                fontSize: 16,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: CupertinoButton.filled(
                    onPressed: () {
                      if (_afghanistanPlans.isNotEmpty) {
                        _launchURL(_afghanistanPlans.first.directLink);
                      } else {
                        _launchURL('https://asim.esimqr.link/');
                      }
                    },
                    child: Text(localization.buyNow),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CupertinoButton(
                    onPressed: () => _launchURL('https://asim.esimqr.link/'),
                    child: Text(localization.contact),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
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
            Icon(
              Icons.public,
              size: 80,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              localization.stayConnectedAfghanistan,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimaryContainer,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              localization.afghanistanDataPlans,
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
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              localization.readyStayConnectedAfghanistan,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              localization.chooseAfghanistanPlan,
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
                '${plan.dataAmount} Afghanistan',
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
}
