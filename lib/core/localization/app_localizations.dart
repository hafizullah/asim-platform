import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

abstract class AppLocalizations {
  AppLocalizations(this.localeName);

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fa'),
    Locale('ps')
  ];

  // App Name
  String get appName;
  String get globalEsimSolutions;

  // Navigation
  String get home;
  String get plans;
  String get about;
  String get contact;

  // Landing Page
  String get welcomeTitle;
  String get welcomeSubtitle;
  String get getStarted;
  String get learnMore;

  // Plans Section
  String get chooseYourPlan;
  String get planDescription;
  String get popular;
  String get buyNow;
  String get perMonth;

  // Features
  String get features;
  String get instantActivation;
  String get instantActivationDesc;
  String get globalCoverage;
  String get globalCoverageDesc;
  String get affordablePrices;
  String get affordablePricesDesc;
  String get noContracts;
  String get noContractsDesc;

  // Common
  String get loading;
  String get error;
  String get retry;
  String get cancel;
  String get ok;
  String get yes;
  String get no;

  // Language selection
  String get selectLanguage;
  String get english;
  String get dari;
  String get pashto;

  // Afghanistan-specific content
  String get stayConnectedAfghanistan;
  String get afghanistanDataPlans;
  String get afghanistanEsimPlans;
  String get afghanistanCoverage;
  String get afghanistanCoverageDesc;
  String get reliableAfghanistanPlans;
  String get readyStayConnectedAfghanistan;
  String get chooseAfghanistanPlan;
  String get afghanistanDataFeatures;
  String get highSpeedData;
  String get support24x7;
  String get competitiveAfghanistanRates;
  String get noPlansAvailable;
  String get purchaseEsim;
  
  // Other countries section
  String get needEsimOtherCountries;
  String get browseAllCountries;
  String get otherCountriesDescription;
  
  // Country name
  String get afghanistan;
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
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
    case 'ps':
      return AppLocalizationsPs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue on GitHub with a '
    'reproducible sample app and the gen-l10n configuration that was used.'
  );
}

// English
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn() : super('en');

  @override
  String get appName => 'Asim';

  @override
  String get globalEsimSolutions => 'Global eSIM Solutions';

  @override
  String get home => 'Home';

  @override
  String get plans => 'Plans';

  @override
  String get about => 'About';

  @override
  String get contact => 'Contact';

  @override
  String get welcomeTitle => 'Stay Connected Worldwide';

  @override
  String get welcomeSubtitle => 'Get instant eSIM data plans for over 190 countries. No physical SIM required.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get learnMore => 'Learn More';

  @override
  String get chooseYourPlan => 'Choose Your Plan';

  @override
  String get planDescription => 'Select the perfect data plan for your travel needs';

  @override
  String get popular => 'Popular';

  @override
  String get buyNow => 'Buy Now';

  @override
  String get perMonth => '/month';

  @override
  String get features => 'Features';

  @override
  String get instantActivation => 'Instant Activation';

  @override
  String get instantActivationDesc => 'Get connected within minutes of purchase';

  @override
  String get globalCoverage => 'Global Coverage';

  @override
  String get globalCoverageDesc => 'Available in 190+ countries worldwide';

  @override
  String get affordablePrices => 'Affordable Prices';

  @override
  String get affordablePricesDesc => 'Competitive rates for all destinations';

  @override
  String get noContracts => 'No Contracts';

  @override
  String get noContractsDesc => 'Pay as you go with flexible plans';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get dari => 'دری';

  @override
  String get pashto => 'پښتو';

  // Afghanistan-specific content
  @override
  String get stayConnectedAfghanistan => 'Stay Connected in Afghanistan';

  @override
  String get afghanistanDataPlans => 'Get instant eSIM data plans for Afghanistan. No physical SIM required.';

  @override
  String get afghanistanEsimPlans => 'Afghanistan eSIM Plans';

  @override
  String get afghanistanCoverage => 'Afghanistan Coverage';

  @override
  String get afghanistanCoverageDesc => 'Reliable network coverage across Afghanistan';

  @override
  String get reliableAfghanistanPlans => 'Stay connected in Afghanistan with our reliable data plans';

  @override
  String get readyStayConnectedAfghanistan => 'Ready to stay connected in Afghanistan?';

  @override
  String get chooseAfghanistanPlan => 'Choose your Afghanistan eSIM plan and stay connected anywhere in the country.';

  @override
  String get afghanistanDataFeatures => 'Afghanistan data';

  @override
  String get highSpeedData => 'High-speed data';

  @override
  String get support24x7 => '24/7 support';

  @override
  String get competitiveAfghanistanRates => 'Competitive rates for Afghanistan data plans';

  @override
  String get noPlansAvailable => 'No plans available';

  @override
  String get purchaseEsim => 'Purchase eSIM';
  
  // Other countries section
  @override
  String get needEsimOtherCountries => 'Need eSIM for Other Countries? 🌍';

  @override
  String get browseAllCountries => 'Browse All Countries';

  @override
  String get otherCountriesDescription => 'We offer eSIM plans for 180+ countries and regions worldwide. Find the perfect plan for your destination.';
  
  // Country name
  @override
  String get afghanistan => 'Afghanistan';
}

// Dari/Farsi
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa() : super('fa');

  @override
  String get appName => 'آسیم';

  @override
  String get globalEsimSolutions => 'راه‌حل‌های جهانی ای‌سیم';

  @override
  String get home => 'خانه';

  @override
  String get plans => 'طرح‌ها';

  @override
  String get about => 'درباره';

  @override
  String get contact => 'تماس';

  @override
  String get welcomeTitle => 'در سراسر جهان متصل بمانید';

  @override
  String get welcomeSubtitle => 'طرح‌های داده ای‌سیم فوری برای بیش از ۱۹۰ کشور دریافت کنید. سیم فیزیکی مورد نیاز نیست.';

  @override
  String get getStarted => 'شروع کنید';

  @override
  String get learnMore => 'بیشتر بدانید';

  @override
  String get chooseYourPlan => 'طرح خود را انتخاب کنید';

  @override
  String get planDescription => 'طرح داده مناسب برای نیازهای سفر خود را انتخاب کنید';

  @override
  String get popular => 'محبوب';

  @override
  String get buyNow => 'همین حالا خرید کنید';

  @override
  String get perMonth => '/ماه';

  @override
  String get features => 'ویژگی‌ها';

  @override
  String get instantActivation => 'فعال‌سازی فوری';

  @override
  String get instantActivationDesc => 'در عرض چند دقیقه پس از خرید متصل شوید';

  @override
  String get globalCoverage => 'پوشش جهانی';

  @override
  String get globalCoverageDesc => 'در بیش از ۱۹۰ کشور جهان در دسترس';

  @override
  String get affordablePrices => 'قیمت‌های مقرون به صرفه';

  @override
  String get affordablePricesDesc => 'نرخ‌های رقابتی برای همه مقاصد';

  @override
  String get noContracts => 'بدون قرارداد';

  @override
  String get noContractsDesc => 'با طرح‌های انعطاف‌پذیر پرداخت کنید';

  @override
  String get loading => 'در حال بارگذاری...';

  @override
  String get error => 'خطا';

  @override
  String get retry => 'تلاش مجدد';

  @override
  String get cancel => 'لغو';

  @override
  String get ok => 'تأیید';

  @override
  String get yes => 'بله';

  @override
  String get no => 'خیر';

  @override
  String get selectLanguage => 'زبان را انتخاب کنید';

  @override
  String get english => 'English';

  @override
  String get dari => 'دری';

  @override
  String get pashto => 'پښتو';

  // Afghanistan-specific content
  @override
  String get stayConnectedAfghanistan => 'در افغانستان متصل بمانید';

  @override
  String get afghanistanDataPlans => 'طرح‌های داده ای‌سیم فوری برای افغانستان دریافت کنید. سیم فیزیکی مورد نیاز نیست.';

  @override
  String get afghanistanEsimPlans => 'طرح‌های ای‌سیم افغانستان';

  @override
  String get afghanistanCoverage => 'پوشش افغانستان';

  @override
  String get afghanistanCoverageDesc => 'پوشش شبکه قابل اعتماد در سراسر افغانستان';

  @override
  String get reliableAfghanistanPlans => 'با طرح‌های قابل اعتماد ما در افغانستان متصل بمانید';

  @override
  String get readyStayConnectedAfghanistan => 'آماده متصل ماندن در افغانستان هستید؟';

  @override
  String get chooseAfghanistanPlan => 'طرح ای‌سیم افغانستان خود را انتخاب کنید و در هر نقطه از کشور متصل بمانید.';

  @override
  String get afghanistanDataFeatures => 'داده افغانستان';

  @override
  String get highSpeedData => 'داده پرسرعت';

  @override
  String get support24x7 => 'پشتیبانی ۲۴/۷';

  @override
  String get competitiveAfghanistanRates => 'نرخ‌های رقابتی برای طرح‌های داده افغانستان';

  @override
  String get noPlansAvailable => 'هیچ طرحی در دسترس نیست';

  @override
  String get purchaseEsim => 'خرید ای‌سیم';
  
  // Other countries section
  @override
  String get needEsimOtherCountries => 'ای‌سیم برای کشورهای دیگر می‌خواهید؟ 🌍';

  @override
  String get browseAllCountries => 'مرور همه کشورها';

  @override
  String get otherCountriesDescription => 'ما طرح‌های ای‌سیم برای ۱۸۰+ کشور و منطقه در سراسر جهان ارائه می‌دهیم. طرح مناسب برای مقصد خود را پیدا کنید.';
  
  // Country name
  @override
  String get afghanistan => 'افغانستان';
}

// Pashto
class AppLocalizationsPs extends AppLocalizations {
  AppLocalizationsPs() : super('ps');

  @override
  String get appName => 'آسیم';

  @override
  String get globalEsimSolutions => 'د نړیوالو ای‌سیم حلونه';

  @override
  String get home => 'کور';

  @override
  String get plans => 'پلانونه';

  @override
  String get about => 'په اړه';

  @override
  String get contact => 'اړیکه';

  @override
  String get welcomeTitle => 'په ټوله نړۍ کې وصل پاتې شئ';

  @override
  String get welcomeSubtitle => 'د ۱۹۰ څخه زیاتو هیوادونو لپاره د ای‌سیم ډیټا پلانونه ترلاسه کړئ. فزیکي سیم ته اړتیا نشته.';

  @override
  String get getStarted => 'پیل وکړئ';

  @override
  String get learnMore => 'نور زده کړئ';

  @override
  String get chooseYourPlan => 'خپل پلان وټاکئ';

  @override
  String get planDescription => 'د خپل سفر اړتیاوو لپاره مناسب ډیټا پلان وټاکئ';

  @override
  String get popular => 'مشهور';

  @override
  String get buyNow => 'اوس وپېرئ';

  @override
  String get perMonth => '/میاشت';

  @override
  String get features => 'ځانګړتیاوې';

  @override
  String get instantActivation => 'سمدستي فعالول';

  @override
  String get instantActivationDesc => 'د پېرودلو څخه په څو دقیقو کې وصل شئ';

  @override
  String get globalCoverage => 'نړیوال پوښښ';

  @override
  String get globalCoverageDesc => 'د نړۍ په ۱۹۰+ هیوادونو کې شتون لري';

  @override
  String get affordablePrices => 'د لاسرسي وړ بیې';

  @override
  String get affordablePricesDesc => 'د ټولو منزلونو لپاره رقابتي نرخونه';

  @override
  String get noContracts => 'هیڅ قرارداد نشته';

  @override
  String get noContractsDesc => 'د انعطاف وړ پلانونو سره تادیه وکړئ';

  @override
  String get loading => 'بارېږي...';

  @override
  String get error => 'تېروتنه';

  @override
  String get retry => 'بیا هڅه وکړئ';

  @override
  String get cancel => 'لغوه کړئ';

  @override
  String get ok => 'سمه ده';

  @override
  String get yes => 'هو';

  @override
  String get no => 'نه';

  @override
  String get selectLanguage => 'ژبه وټاکئ';

  @override
  String get english => 'English';

  @override
  String get dari => 'دری';

  @override
  String get pashto => 'پښتو';

  // Afghanistan-specific content
  @override
  String get stayConnectedAfghanistan => 'په افغانستان کې وصل پاتې شئ';

  @override
  String get afghanistanDataPlans => 'د افغانستان لپاره د ای‌سیم ډیټا پلانونه ترلاسه کړئ. فزیکي سیم ته اړتیا نشته.';

  @override
  String get afghanistanEsimPlans => 'د افغانستان ای‌سیم پلانونه';

  @override
  String get afghanistanCoverage => 'د افغانستان پوښښ';

  @override
  String get afghanistanCoverageDesc => 'په ټول افغانستان کې د اعتماد وړ شبکې پوښښ';

  @override
  String get reliableAfghanistanPlans => 'زموږ د اعتماد وړ پلانونو سره په افغانستان کې وصل پاتې شئ';

  @override
  String get readyStayConnectedAfghanistan => 'په افغانستان کې د وصل پاتې کیدو لپاره چمتو یاست؟';

  @override
  String get chooseAfghanistanPlan => 'خپل د افغانستان ای‌سیم پلان وټاکئ او د هیواد په هره برخه کې وصل پاتې شئ.';

  @override
  String get afghanistanDataFeatures => 'د افغانستان ډیټا';

  @override
  String get highSpeedData => 'د لوړ سرعت ډیټا';

  @override
  String get support24x7 => '۲۴/۷ ملاتړ';

  @override
  String get competitiveAfghanistanRates => 'د افغانستان ډیټا پلانونو لپاره رقابتي نرخونه';

  @override
  String get noPlansAvailable => 'هیڅ پلان شتون نلري';

  @override
  String get purchaseEsim => 'ای‌سیم وپېرئ';
  
  // Other countries section
  @override
  String get needEsimOtherCountries => 'د نورو هیوادونو لپاره ای‌سیم غواړئ؟ 🌍';

  @override
  String get browseAllCountries => 'ټول هیوادونه وګورئ';

  @override
  String get otherCountriesDescription => 'موږ د نړۍ د ۱۸۰+ هیوادونو او سیمو لپاره د ای‌سیم پلانونه وړاندې کوو. د خپل منزل لپاره مناسب پلان ومومئ.';
  
  // Country name
  @override
  String get afghanistan => 'افغانستان';
}
