import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/services.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:provider/provider.dart";
import "dart:io";
import "core/providers/language_provider.dart";
import "core/localization/app_localizations.dart";
import "screens/landing_page.dart";

void main() {
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
          // Use platform-adaptive app
          return Platform.isIOS
              ? _buildCupertinoApp(languageProvider)
              : _buildMaterialApp(languageProvider);
        },
      ),
    );
  }

  Widget _buildCupertinoApp(LanguageProvider languageProvider) {
    return CupertinoApp(
      title: "Asim - Global eSIM Solutions",
      debugShowCheckedModeBanner: false,
      
      // iOS-style theme
      theme: const CupertinoThemeData(
        primaryColor: Color(0xFF2E7D32),
        scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
        textTheme: CupertinoTextThemeData(
          primaryColor: Color(0xFF2E7D32),
        ),
      ),
      
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
      
      // Builder to wrap with Directionality for RTL support
      builder: (context, child) {
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

  Widget _buildMaterialApp(LanguageProvider languageProvider) {
    return MaterialApp(
      title: "Asim - Global eSIM Solutions",
      debugShowCheckedModeBanner: false,
      
      // Modern Material 3 Theme
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32), // Professional green
          brightness: Brightness.light,
        ),
        fontFamily: "Roboto",
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
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
      
      // Builder to wrap with Directionality for RTL support
      builder: (context, child) {
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
