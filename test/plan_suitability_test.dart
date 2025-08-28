import 'package:flutter_test/flutter_test.dart';
import 'package:asim_platform/core/models/esim_plan.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Plan Suitability Tests', () {
    test('should return correct suitability for daily plans', () {
      final plan = EsimPlan(
        name: 'Afghanistan 1GB/Day',
        slug: 'AF_1_Daily',
        costUsd: 4.00,
        retailUsd: 5.89,
        directLink: 'https://test.com',
        shopLink: 'https://test.com',
      );

      expect(plan.getSuitabilityType(), equals('daily'));
    });

    test('should return correct suitability for short trips (7 days)', () {
      final plan = EsimPlan(
        name: 'Afghanistan 1GB 7Days',
        slug: 'AF_1_7',
        costUsd: 4.50,
        retailUsd: 6.48,
        directLink: 'https://test.com',
        shopLink: 'https://test.com',
      );

      expect(plan.getSuitabilityType(), equals('short'));
    });

    test('should return correct suitability for weekly trips (15 days)', () {
      final plan = EsimPlan(
        name: 'Afghanistan 3GB 15Days',
        slug: 'AF_3_15',
        costUsd: 11.80,
        retailUsd: 15.06,
        directLink: 'https://test.com',
        shopLink: 'https://test.com',
      );

      expect(plan.getSuitabilityType(), equals('weekly'));
    });

    test('should return correct suitability for monthly plans', () {
      final plan = EsimPlan(
        name: 'Afghanistan 5GB 30Days',
        slug: 'AF_5_30',
        costUsd: 19.60,
        retailUsd: 24.24,
        directLink: 'https://test.com',
        shopLink: 'https://test.com',
      );

      expect(plan.getSuitabilityType(), equals('monthly'));
    });

    test('should return correct suitability for heavy data users (high GB + 30 days)', () {
      final plan = EsimPlan(
        name: 'Afghanistan 20GB 30Days',
        slug: 'AF_20_30',
        costUsd: 68.60,
        retailUsd: 81.89,
        directLink: 'https://test.com',
        shopLink: 'https://test.com',
      );

      expect(plan.getSuitabilityType(), equals('heavy'));
    });

    test('should handle plans without clear duration pattern', () {
      final plan = EsimPlan(
        name: 'Afghanistan Basic Plan',
        slug: 'AF_basic',
        costUsd: 10.00,
        retailUsd: 12.00,
        directLink: 'https://test.com',
        shopLink: 'https://test.com',
      );

      expect(plan.getSuitabilityType(), equals('default'));
    });
  });
}
