import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_ps.dart';

/// Callers can lookup localized strings with Lookup.of(context).
///
/// If this widget is inserted into the widget tree above some [Locale]
/// widget that supports [AppLocalizations], the [AppLocalizations] will
/// be automatically synchronized to the default [Locale].
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fa'),
    Locale('ps')
  ];

  // Common
  String get appName;
  String get welcome;
  String get cancel;
  String get confirm;
  String get save;
  String get delete;
  String get edit;
  String get loading;
  String get error;
  String get success;
  String get tryAgain;
  String get ok;
  String get yes;
  String get no;

  // Auth
  String get login;
  String get register;
  String get logout;
  String get email;
  String get password;
  String get confirmPassword;
  String get firstName;
  String get lastName;
  String get phoneNumber;
  String get forgotPassword;
  String get resetPassword;
  String get createAccount;
  String get alreadyHaveAccount;
  String get dontHaveAccount;
  String get signInWithGoogle;
  String get signInWithPhone;
  String get enterOtp;
  String get resendOtp;

  // Home
  String get selectCountry;
  String get browsePlans;
  String get popularDestinations;
  String get recentOrders;
  String get quickActions;

  // Plans
  String get dataPlans;
  String get selectPlan;
  String get planDetails;
  String get dataAmount;
  String get duration;
  String get price;
  String get coverage;
  String get networks;
  String get unlimited;
  String get popular;
  String get recommended;
  String get tourist;
  String get filterPlans;
  String get sortBy;
  String get priceRange;
  String get dataRange;
  String get durationRange;

  // Checkout
  String get checkout;
  String get orderSummary;
  String get paymentMethod;
  String get total;
  String get subtotal;
  String get tax;
  String get payNow;
  String get processingPayment;
  String get paymentSuccessful;
  String get paymentFailed;

  // Orders
  String get myOrders;
  String get orderHistory;
  String get orderDetails;
  String get orderStatus;
  String get pending;
  String get processing;
  String get completed;
  String get failed;
  String get cancelled;
  String get activated;
  String get expired;
  String get activate;
  String get downloadQR;
  String get shareDetails;
  String get sendToEmail;
  String get sendToWhatsApp;

  // Profile
  String get profile;
  String get personalInfo;
  String get settings;
  String get language;
  String get currency;
  String get notifications;
  String get privacy;
  String get terms;
  String get support;
  String get about;

  // eSIM
  String get esim;
  String get installEsim;
  String get scanQrCode;
  String get activationCode;
  String get networkSettings;
  String get dataUsage;
  String get roaming;

  // Countries
  String get afghanistan;
  String get unitedStates;
  String get unitedKingdom;
  String get germany;
  String get france;
  String get italy;
  String get spain;
  String get turkey;
  String get uae;
  String get saudiArabia;
  String get pakistan;
  String get india;
  String get china;
  String get japan;
  String get southKorea;

  // Errors
  String get networkError;
  String get serverError;
  String get authenticationError;
  String get permissionError;
  String get validationError;
  String get unknownError;

  // Validation
  String get fieldRequired;
  String get invalidEmail;
  String get passwordTooShort;
  String get passwordsDoNotMatch;
  String get invalidPhoneNumber;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fa', 'ps'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fa': return AppLocalizationsFa();
    case 'ps': return AppLocalizationsPs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue on GitHub with a '
    'reproducible sample app and the gen-l10n configuration that was used.'
  );
}
