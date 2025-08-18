import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myOrders),
      ),
      body: const Center(
        child: Text('Orders Screen - Coming Soon'),
      ),
    );
  }
}
