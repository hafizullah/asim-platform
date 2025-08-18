import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/plans/screens/plans_screen.dart';
import '../../features/plans/screens/plan_details_screen.dart';
import '../../features/checkout/screens/checkout_screen.dart';
import '../../features/orders/screens/orders_screen.dart';
import '../../features/orders/screens/order_details_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/onboarding',
    routes: [
      // Onboarding
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      
      // Authentication routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      
      // Main app routes with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/plans',
            name: 'plans',
            builder: (context, state) {
              final countryCode = state.uri.queryParameters['country'];
              return PlansScreen(countryCode: countryCode);
            },
          ),
          GoRoute(
            path: '/orders',
            name: 'orders',
            builder: (context, state) => const OrdersScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      
      // Detail routes (full screen)
      GoRoute(
        path: '/plan/:planId',
        name: 'plan-details',
        builder: (context, state) {
          final planId = state.pathParameters['planId']!;
          return PlanDetailsScreen(planId: planId);
        },
      ),
      GoRoute(
        path: '/checkout/:planId',
        name: 'checkout',
        builder: (context, state) {
          final planId = state.pathParameters['planId']!;
          return CheckoutScreen(planId: planId);
        },
      ),
      GoRoute(
        path: '/order/:orderId',
        name: 'order-details',
        builder: (context, state) {
          final orderId = state.pathParameters['orderId']!;
          return OrderDetailsScreen(orderId: orderId);
        },
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isAuthenticated = authProvider.isAuthenticated;
      final isOnboardingPath = state.matchedLocation == '/onboarding';
      final isAuthPath = ['/login', '/register', '/forgot-password'].contains(state.matchedLocation);
      
      // If not authenticated and not on auth/onboarding path, redirect to onboarding
      if (!isAuthenticated && !isAuthPath && !isOnboardingPath) {
        return '/onboarding';
      }
      
      // If authenticated and on auth/onboarding path, redirect to home
      if (isAuthenticated && (isAuthPath || isOnboardingPath)) {
        return '/';
      }
      
      return null;
    },
  );
}

class MainShell extends StatefulWidget {
  final Widget child;
  
  const MainShell({super.key, required this.child});
  
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  
  final List<String> _routes = [
    '/',
    '/plans',
    '/orders',
    '/profile',
  ];
  
  void _onTabTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      context.go(_routes[index]);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // Update current index based on current route
    final currentRoute = GoRouterState.of(context).matchedLocation;
    if (_routes.contains(currentRoute)) {
      _currentIndex = _routes.indexOf(currentRoute);
    }
    
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sim_card),
            label: 'Plans',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
