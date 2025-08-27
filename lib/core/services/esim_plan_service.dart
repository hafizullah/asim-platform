import 'package:flutter/services.dart';
import '../models/esim_plan.dart';

class EsimPlanService {
  static const String _csvAssetPath = 'assets/esim-plans.csv';
  
  static List<EsimPlan>? _cachedAfghanistanPlans;

  /// Load and parse Afghanistan plans from CSV
  static Future<List<EsimPlan>> getAfghanistanPlans() async {
    if (_cachedAfghanistanPlans != null) {
      return _cachedAfghanistanPlans!;
    }

    try {
      final String csvContent = await rootBundle.loadString(_csvAssetPath);
      final List<String> lines = csvContent.split('\n');
      
      // Skip header row and filter Afghanistan plans
      final afghanistanPlans = <EsimPlan>[];
      
      for (int i = 1; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;
        
        // Check if this line contains Afghanistan plans
        if (line.toLowerCase().contains('afghanistan')) {
          try {
            final plan = EsimPlan.fromCsv(line);
            afghanistanPlans.add(plan);
          } catch (e) {
            print('Error parsing plan from line: $line');
            print('Error: $e');
          }
        }
      }

      // Sort plans by price (ascending)
      afghanistanPlans.sort((a, b) => a.retailUsd.compareTo(b.retailUsd));
      
      _cachedAfghanistanPlans = afghanistanPlans;
      return afghanistanPlans;
    } catch (e) {
      print('Error loading Afghanistan plans: $e');
      return [];
    }
  }

  /// Get featured Afghanistan plans (top 3-4 most popular)
  static Future<List<EsimPlan>> getFeaturedAfghanistanPlans() async {
    final allPlans = await getAfghanistanPlans();
    
    // Select a good mix of plans for display
    final featured = <EsimPlan>[];
    
    // Add some variety: daily, weekly, and monthly plans
    for (final plan in allPlans) {
      if (plan.name.contains('1GB 7Days') && featured.length < 4) {
        featured.add(plan);
      } else if (plan.name.contains('3GB 30Days') && featured.length < 4) {
        featured.add(plan);
      } else if (plan.name.contains('5GB 30Days') && featured.length < 4) {
        featured.add(plan);
      } else if (plan.name.contains('1GB/Day') && featured.length < 4) {
        featured.add(plan);
      }
    }
    
    // If we don't have enough, add more plans
    if (featured.length < 3) {
      for (final plan in allPlans) {
        if (!featured.contains(plan) && featured.length < 4) {
          featured.add(plan);
        }
      }
    }
    
    return featured;
  }

  /// Clear cache (useful for testing or refreshing data)
  static void clearCache() {
    _cachedAfghanistanPlans = null;
  }
}
