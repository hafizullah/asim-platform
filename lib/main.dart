import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

// import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
// import 'core/localization/app_localizations.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/esim_provider.dart';
// import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (temporarily disabled for testing)
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  
  runApp(const AsimApp());
}

class AsimApp extends StatelessWidget {
  const AsimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ESimProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            title: 'Asim - eSIM Platform',
            debugShowCheckedModeBanner: false,
            
            // Theme
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            
            // Localization
            locale: localeProvider.locale,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'US'), // English
              Locale('ps', 'AF'), // Pashto
              Locale('fa', 'AF'), // Dari
            ],
            
            // Simple home page for testing
            home: const TestHomePage(),
          );
        },
      ),
    );
  }
}

class TestHomePage extends StatelessWidget {
  const TestHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ASIM Platform'),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sim_card,
              size: 100,
              color: Color(0xFF2E7D32),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to ASIM Platform',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Your eSIM solution for global connectivity',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 40),
            Card(
              margin: EdgeInsets.all(20),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Features',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    ListTile(
                      leading: Icon(Icons.public, color: Color(0xFF2E7D32)),
                      title: Text('Global Coverage'),
                      subtitle: Text('Connect anywhere in the world'),
                    ),
                    ListTile(
                      leading: Icon(Icons.speed, color: Color(0xFF2E7D32)),
                      title: Text('High-Speed Data'),
                      subtitle: Text('4G/5G connectivity'),
                    ),
                    ListTile(
                      leading: Icon(Icons.security, color: Color(0xFF2E7D32)),
                      title: Text('Secure & Reliable'),
                      subtitle: Text('Enterprise-grade security'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Future: Navigate to plans
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Browse Plans feature coming soon!'),
            ),
          );
        },
        icon: const Icon(Icons.explore),
        label: const Text('Browse Plans'),
      ),
    );
  }
}
