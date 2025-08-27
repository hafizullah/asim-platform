import 'package:flutter_test/flutter_test.dart';
import 'package:asim_platform/core/services/esim_plan_service.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Afghanistan eSIM Plans', () {
    test('should load Afghanistan plans from CSV', () async {
      final plans = await EsimPlanService.getAfghanistanPlans();
      
      expect(plans, isNotEmpty);
      expect(plans.length, equals(9)); // We found 9 Afghanistan plans
      
      // Check that all plans are for Afghanistan
      for (final plan in plans) {
        expect(plan.name.toLowerCase(), contains('afghanistan'));
      }
    });

    test('should get featured Afghanistan plans', () async {
      final featuredPlans = await EsimPlanService.getFeaturedAfghanistanPlans();
      
      expect(featuredPlans, isNotEmpty);
      expect(featuredPlans.length, lessThanOrEqualTo(4));
      
      // Check that all featured plans are for Afghanistan
      for (final plan in featuredPlans) {
        expect(plan.name.toLowerCase(), contains('afghanistan'));
      }
    });

    test('should parse plan data correctly', () async {
      final plans = await EsimPlanService.getAfghanistanPlans();
      final firstPlan = plans.first;
      
      expect(firstPlan.name, isNotEmpty);
      expect(firstPlan.slug, isNotEmpty);
      expect(firstPlan.retailUsd, greaterThan(0));
      expect(firstPlan.directLink, isNotEmpty);
      expect(firstPlan.shopLink, isNotEmpty);
      expect(firstPlan.formattedPrice, startsWith('\$'));
    });

    test('should identify data amounts correctly', () async {
      final plans = await EsimPlanService.getAfghanistanPlans();
      
      for (final plan in plans) {
        final dataAmount = plan.dataAmount;
        expect(dataAmount, isNotEmpty);
        // Should contain GB or MB
        expect(dataAmount, anyOf(contains('GB'), contains('MB')));
      }
    });

    test('should identify duration correctly', () async {
      final plans = await EsimPlanService.getAfghanistanPlans();
      
      for (final plan in plans) {
        final duration = plan.duration;
        expect(duration, isNotEmpty);
        // Should contain days or "per day"
        expect(duration, anyOf(contains('day'), contains('days')));
      }
    });
  });
}
