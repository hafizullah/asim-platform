import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:provider/provider.dart";
import "core/providers/language_provider.dart";
import "core/localization/app_localizations.dart";
import "screens/landing_page.dart";

void main() {
  // Ensure WebView platform is initialized properly
  WidgetsFlutterBinding.ensureInitialized();
  
  // Add error handling for uncaught exceptions
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };
  
  runApp(const AsimLandingApp());
}

class AsimLandingApp extends StatelessWidget {
  const AsimLandingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          // For web, always use Material Design
          // For mobile, use platform-adaptive app but default to Material for broader compatibility
          return _buildMaterialApp(languageProvider);
        },
      ),
    );
  }

  Widget _buildMaterialApp(LanguageProvider languageProvider) {
    return MaterialApp(
      title: "ASIM Platform - Professional eSIM Solutions",
      debugShowCheckedModeBanner: false,
      
      // Modern Material 3 Theme with ASIM brand colors
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF228B22), // ASIM brand green
          brightness: Brightness.light,
        ),
        fontFamily: "Roboto",
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF228B22), // ASIM brand green
          brightness: Brightness.dark,
        ),
        fontFamily: "Roboto",
      ),
      themeMode: ThemeMode.system,
      
      // Localization and RTL support
      locale: languageProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("en", ""), // English
        Locale("fa", ""), // Dari/Persian
        Locale("ps", ""), // Pashto
      ],
      
      // Add error handling
      builder: (context, child) {
        // Add error handling
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return Material(
            child: Container(
              color: Colors.red,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.white, size: 64),
                    const SizedBox(height: 16),
                    const Text(
                      'An error occurred',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      details.exception.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        };
        
        final locale = Localizations.localeOf(context);
        final isRTL = locale.languageCode == 'fa' || locale.languageCode == 'ps';
        
        return Directionality(
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        );
      },
      
      home: const LandingPage(),
    );
  }
}
