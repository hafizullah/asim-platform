import 'package:flutter/services.dart';

class SeoService {
  static const String baseUrl = 'https://www.asim.af';
  static const String siteName = 'ASIM Platform';
  static const String companyName = 'ASIM Platform';
  
  // SEO Meta Tags for different pages
  static const Map<String, Map<String, String>> pageMetadata = {
    'home': {
      'title': 'Stay Connected in Afghanistan 📱 | ASIM eSIM - Your Digital Gateway to Afghanistan',
      'description': '🚀 Unlock Afghanistan instantly! Get lightning-fast eSIM data plans with zero hassle. No SIM cards, no queues, no borders - just pure connectivity magic. Trusted by travelers, loved by locals. 24/7 support in your language!',
      'keywords': 'eSIM Afghanistan, mobile data Afghanistan, eSIM plans, Afghanistan connectivity, mobile internet Afghanistan, travel eSIM, instant activation, ASIM platform, digital SIM card, Afghanistan telecommunications',
      'ogImage': '$baseUrl/android-chrome-512x512.png',
    },
    'about': {
      'title': 'The Story Behind ASIM Magic ✨ | How We\'re Revolutionizing Afghanistan Connectivity',
      'description': 'Meet the team making Afghanistan more connected than ever! Discover how ASIM became the go-to eSIM solution for smart travelers and tech-savvy locals. Our mission: making connectivity effortless.',
      'keywords': 'about ASIM, eSIM provider Afghanistan, mobile connectivity company, Afghanistan telecommunications',
      'ogImage': '$baseUrl/android-chrome-512x512.png',
    },
    'contact': {
      'title': 'Need Help? We\'re Here 24/7! 🚀 | ASIM Support That Actually Cares',
      'description': 'Stuck? Confused? Just want to chat? Our friendly support ninjas are standing by 24/7 in English, Dari, and Pashto. Real humans, real solutions, real fast!',
      'keywords': 'contact ASIM, customer support, eSIM help, Afghanistan mobile support',
      'ogImage': '$baseUrl/android-chrome-512x512.png',
    },
    'terms': {
      'title': 'The Fine Print (But Make It Fun) 📋 | ASIM Terms & Conditions',
      'description': 'Yes, we have terms and conditions - but ours are actually readable! Understanding your rights and our promises for ASIM eSIM services. No legal jargon, just straight talk.',
      'keywords': 'terms conditions ASIM, eSIM terms, service agreement',
      'ogImage': '$baseUrl/android-chrome-512x512.png',
    },
  };

  // Structured Data for different content types
  static Map<String, dynamic> getOrganizationStructuredData() {
    return {
      "@context": "https://schema.org",
      "@type": "Organization",
      "name": companyName,
      "description": "Your digital gateway to Afghanistan! Lightning-fast eSIM connectivity with zero hassle - no SIM cards, no queues, just pure connection magic.",
      "url": baseUrl,
      "logo": "$baseUrl/android-chrome-512x512.png",
      "contactPoint": {
        "@type": "ContactPoint",
        "contactType": "customer service",
        "availableLanguage": ["English", "Dari", "Pashto"]
      },
      "areaServed": {
        "@type": "Country",
        "name": "Afghanistan"
      },
      "serviceType": "eSIM Data Plans",
      "sameAs": []
    };
  }

  static Map<String, dynamic> getProductStructuredData() {
    return {
      "@context": "https://schema.org",
      "@type": "Product",
      "name": "Afghanistan eSIM Data Plans - Instant Connection Magic",
      "description": "Skip the SIM card hunt! Get instant eSIM data for Afghanistan with lightning-fast activation. Perfect for travelers who want to stay connected without the hassle.",
      "brand": {
        "@type": "Brand",
        "name": companyName
      },
      "offers": {
        "@type": "AggregateOffer",
        "availability": "https://schema.org/InStock",
        "priceCurrency": "USD",
        "lowPrice": "5",
        "highPrice": "50",
        "offerCount": "10"
      },
      "aggregateRating": {
        "@type": "AggregateRating",
        "ratingValue": "4.8",
        "reviewCount": "150"
      }
    };
  }

  static Map<String, dynamic> getBreadcrumbStructuredData(List<Map<String, String>> breadcrumbs) {
    return {
      "@context": "https://schema.org",
      "@type": "BreadcrumbList",
      "itemListElement": breadcrumbs.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, String> item = entry.value;
        return {
          "@type": "ListItem",
          "position": index + 1,
          "name": item['name'],
          "item": "${baseUrl}${item['url']}"
        };
      }).toList()
    };
  }

  // SEO Keywords by category
  static const Map<String, List<String>> keywordCategories = {
    'primary': [
      'eSIM Afghanistan',
      'Afghanistan mobile data',
      'eSIM plans Afghanistan',
      'digital SIM Afghanistan',
      'mobile internet Afghanistan'
    ],
    'travel': [
      'travel eSIM Afghanistan',
      'Afghanistan travel connectivity',
      'tourist eSIM Afghanistan',
      'international roaming Afghanistan'
    ],
    'features': [
      'instant activation eSIM',
      '24/7 support eSIM',
      'affordable eSIM plans',
      'reliable mobile data',
      'no contract eSIM'
    ],
    'languages': [
      'eSIM Dari support',
      'eSIM Pashto support',
      'multilingual eSIM service',
      'Afghanistan local language support'
    ]
  };

  // Generate keyword string for meta tags
  static String generateKeywords([List<String>? additionalKeywords]) {
    List<String> allKeywords = [];
    keywordCategories.values.forEach((category) {
      allKeywords.addAll(category);
    });
    
    if (additionalKeywords != null) {
      allKeywords.addAll(additionalKeywords);
    }
    
    return allKeywords.join(', ');
  }

  // Update page title for SEO
  static void updatePageTitle(String pageKey) {
    final metadata = pageMetadata[pageKey];
    if (metadata != null && metadata['title'] != null) {
      SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
          label: metadata['title']!,
          primaryColor: 0xFF006633, // ASIM brand green
        ),
      );
    }
  }
}
