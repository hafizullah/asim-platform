import 'package:flutter/material.dart';
import '../models/esim_plan.dart';
import '../models/esim_order.dart';
import '../models/country.dart';

class ESimProvider extends ChangeNotifier {
  List<Country> _countries = [];
  List<ESimPlan> _plans = [];
  List<ESimOrder> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;
  ESimPlan? _selectedPlan;
  Country? _selectedCountry;
  
  List<Country> get countries => _countries;
  List<ESimPlan> get plans => _plans;
  List<ESimOrder> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ESimPlan? get selectedPlan => _selectedPlan;
  Country? get selectedCountry => _selectedCountry;
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }
  
  Future<void> loadCountries() async {
    try {
      _setLoading(true);
      _setError(null);
      
      // Demo data for countries
      _countries = [
        Country(
          code: 'US',
          name: 'United States',
          flagUrl: 'https://flagsapi.com/US/flat/64.png',
          currency: 'USD',
          supportedNetworks: ['4G', '5G'],
        ),
        Country(
          code: 'GB',
          name: 'United Kingdom',
          flagUrl: 'https://flagsapi.com/GB/flat/64.png',
          currency: 'GBP',
          supportedNetworks: ['4G', '5G'],
        ),
        Country(
          code: 'AF',
          name: 'Afghanistan',
          flagUrl: 'https://flagsapi.com/AF/flat/64.png',
          currency: 'AFN',
          supportedNetworks: ['3G', '4G'],
        ),
      ];
      
      _countries.sort((a, b) => a.name.compareTo(b.name));
      
    } catch (e) {
      _setError('Failed to load countries: \$e');
    } finally {
      _setLoading(false);
    }
  }
  
  void clearError() {
    _setError(null);
  }
  
  Future<void> loadPlansForCountry(String countryCode) async {
    try {
      _setLoading(true);
      _setError(null);
      
      // Demo data for plans
      _plans = [
        ESimPlan(
          id: 'plan_1_$countryCode',
          name: '5GB - 30 Days',
          countryCode: countryCode,
          countryName: _selectedCountry?.name ?? 'Unknown',
          dataAmountGB: 5,
          durationDays: 30,
          price: 25.0,
          currency: 'USD',
          description: 'Perfect for travelers',
          supportedNetworks: ['4G', '5G'],
          isPopular: true,
          provider: 'TelecomProvider',
          coverage: 'Nationwide',
          activationPolicy: 'Instant',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ESimPlan(
          id: 'plan_2_$countryCode',
          name: '10GB - 30 Days',
          countryCode: countryCode,
          countryName: _selectedCountry?.name ?? 'Unknown',
          dataAmountGB: 10,
          durationDays: 30,
          price: 45.0,
          currency: 'USD',
          description: 'For heavy users',
          supportedNetworks: ['4G', '5G'],
          isPopular: false,
          provider: 'TelecomProvider',
          coverage: 'Nationwide',
          activationPolicy: 'Instant',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ESimPlan(
          id: 'plan_3_$countryCode',
          name: '1GB - 7 Days',
          countryCode: countryCode,
          countryName: _selectedCountry?.name ?? 'Unknown',
          dataAmountGB: 1,
          durationDays: 7,
          price: 9.99,
          currency: 'USD',
          description: 'Short stay option',
          supportedNetworks: ['4G'],
          isPopular: false,
          provider: 'TelecomProvider',
          coverage: 'Major cities',
          activationPolicy: 'Instant',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
      
      _plans.sort((a, b) => a.price.compareTo(b.price));
      
    } catch (e) {
      _setError('Failed to load plans: \$e');
      _plans = [];
    } finally {
      _setLoading(false);
    }
  }
  
  void selectPlan(ESimPlan plan) {
    _selectedPlan = plan;
    notifyListeners();
  }
  
  void selectCountry(Country country) {
    _selectedCountry = country;
    _selectedPlan = null;
    notifyListeners();
  }
  
  void clearSelection() {
    _selectedPlan = null;
    _selectedCountry = null;
    notifyListeners();
  }
}
