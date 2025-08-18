import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/providers/locale_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Global eSIM Connection',
      description: 'Stay connected anywhere in the world with our affordable eSIM plans',
      image: 'assets/images/onboarding_1.png',
      icon: Icons.public,
    ),
    OnboardingPage(
      title: 'Easy 3-Step Process',
      description: 'Select your plan, pay securely, and activate instantly',
      image: 'assets/images/onboarding_2.png',
      icon: Icons.touch_app,
    ),
    OnboardingPage(
      title: 'Send to Anyone',
      description: 'Buy data plans for family and friends abroad via email or WhatsApp',
      image: 'assets/images/onboarding_3.png',
      icon: Icons.send,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Language selector
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DropdownButton<Locale>(
                    value: localeProvider.locale,
                    items: LocaleProvider.supportedLocales.map((locale) {
                      return DropdownMenuItem<Locale>(
                        value: locale,
                        child: Text(
                          localeProvider.getLanguageName(locale),
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }).toList(),
                    onChanged: (locale) {
                      if (locale != null) {
                        localeProvider.setLocale(locale);
                      }
                    },
                  ),
                ],
              ),
            ),
            
            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index], context);
                },
              ),
            ),
            
            // Page indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            
            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Text(l10n.cancel),
                    )
                  else
                    const SizedBox(width: 80),
                  
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        context.go('/login');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: Text(
                      _currentPage < _pages.length - 1 ? 'Next' : 'Get Started',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon or image placeholder
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(
              page.icon,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
          ),
          
          const SizedBox(height: 48),
          
          Text(
            page.title,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          Text(
            page.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey.shade600,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String image;
  final IconData icon;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.image,
    required this.icon,
  });
}
