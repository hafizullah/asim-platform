import '../localization/app_localizations.dart';
import '../models/esim_plan.dart';

class PlanLocalizationUtils {
  /// Get localized duration text for a plan
  static String getLocalizedDuration(EsimPlan plan, AppLocalizations localization) {
    if (plan.name.contains('/Day')) {
      return localization.perDay;
    } else if (plan.name.contains('Days')) {
      final RegExp durationRegex = RegExp(r'(\d+)\s*Days');
      final match = durationRegex.firstMatch(plan.name);
      if (match != null) {
        final daysCount = int.parse(match.group(1)!);
        final localizedNumber = localization.formatNumber(daysCount.toString());
        return '$localizedNumber ${localization.days}';
      }
    }
    return '';
  }

  /// Get localized price with currency formatting
  static String getLocalizedPrice(EsimPlan plan, AppLocalizations localization) {
    final priceString = plan.retailUsd.toStringAsFixed(2);
    final localizedPrice = localization.formatNumber(priceString);
    return '\$$localizedPrice';
  }

  /// Get localized data amount
  static String getLocalizedDataAmount(EsimPlan plan, AppLocalizations localization) {
    final RegExp dataRegex = RegExp(r'(\d+(?:\.\d+)?)(MB|GB)');
    final match = dataRegex.firstMatch(plan.name);
    if (match != null) {
      final amount = match.group(1)!;
      final unit = match.group(2)!;
      final localizedAmount = localization.formatNumber(amount);
      return '$localizedAmount$unit';
    }
    return '';
  }

  /// Get full localized plan description
  static String getLocalizedPlanDescription(EsimPlan plan, AppLocalizations localization) {
    final dataAmount = getLocalizedDataAmount(plan, localization);
    final duration = getLocalizedDuration(plan, localization);
    
    if (dataAmount.isNotEmpty && duration.isNotEmpty) {
      return '$dataAmount ${localization.afghanistanDataFeatures} $duration';
    } else if (dataAmount.isNotEmpty) {
      return '$dataAmount ${localization.afghanistanDataFeatures}';
    }
    return plan.name;
  }
}
