import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';

class PlansScreen extends StatelessWidget {
  final String? countryCode;
  
  const PlansScreen({super.key, this.countryCode});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dataPlans),
      ),
      body: const Center(
        child: Text('Plans Screen - Coming Soon'),
      ),
    );
  }
}
