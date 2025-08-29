import 'package:flutter/foundation.dart';

class AnalyticsService {
  static const String googleAnalyticsId = 'G-T3VYW81YP4';
  static const String googleSearchConsoleId = 'XXXXXXXXXX'; // Replace with your Search Console ID
  
  // Track page views for SEO
  static void trackPageView(String pageName, {Map<String, dynamic>? parameters}) {
    if (kIsWeb) {
      // Log page view for analytics
      debugPrint('Page View: $pageName');
      if (parameters != null) {
        debugPrint('Parameters: $parameters');
      }
      
      // In a real implementation, you would send this to Google Analytics
      // Example: gtag('event', 'page_view', { 'page_title': pageName });
    }
  }
  
  // Track user interactions for SEO insights
  static void trackEvent(String eventName, Map<String, dynamic> parameters) {
    if (kIsWeb) {
      debugPrint('Event: $eventName');
      debugPrint('Parameters: $parameters');
      
      // In a real implementation, you would send this to Google Analytics
      // Example: gtag('event', eventName, parameters);
    }
  }
  
  // Track eSIM plan views for conversion tracking
  static void trackEsimPlanView(String planName, String planPrice) {
    trackEvent('view_item', {
      'item_id': planName.toLowerCase().replaceAll(' ', '_'),
      'item_name': planName,
      'item_category': 'esim_plan',
      'item_category2': 'afghanistan',
      'price': planPrice,
      'currency': 'USD',
    });
  }
  
  // Track eSIM plan purchases for conversion tracking
  static void trackEsimPlanPurchase(String planName, String planPrice) {
    trackEvent('purchase', {
      'transaction_id': DateTime.now().millisecondsSinceEpoch.toString(),
      'value': planPrice,
      'currency': 'USD',
      'items': [{
        'item_id': planName.toLowerCase().replaceAll(' ', '_'),
        'item_name': planName,
        'item_category': 'esim_plan',
        'quantity': 1,
        'price': planPrice,
      }]
    });
  }
  
  // Track language changes for localization insights
  static void trackLanguageChange(String fromLanguage, String toLanguage) {
    trackEvent('language_change', {
      'from_language': fromLanguage,
      'to_language': toLanguage,
    });
  }
  
  // Track contact form submissions
  static void trackContactSubmission(String contactMethod) {
    trackEvent('contact_submission', {
      'method': contactMethod,
    });
  }
}
