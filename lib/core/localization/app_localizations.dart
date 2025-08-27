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
  
  // Terms and Conditions
  String get termsAndConditions;
  String get termsAndConditionsTitle;
  
  // About Us page
  String get aboutUsTitle;
  String get ourMission;
  String get ourMissionDesc;
  String get pioneering;
  String get pioneeringDesc;
  String get whyChooseUs;
  String get dedicatedToAfghanistan;
  String get dedicatedToAfghanistanDesc;
  String get instantConnectivity;
  String get instantConnectivityDesc;
  String get reliableNetwork;
  String get reliableNetworkDesc;
  String get affordableRates;
  String get affordableRatesDesc;
  String get localSupport;
  String get localSupportDesc;
  String get ourVision;
  String get ourVisionDesc;
  String get getConnected;
  String get firstEsimProvider;
  String get joinThousands;
  String get trustedByTravelers;
  String get backToHome;
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
  
  // Terms and Conditions
  @override
  String get termsAndConditions => 'Terms & Conditions';
  
  @override
  String get termsAndConditionsTitle => 'Terms and Conditions';
  
  // About Us page
  @override
  String get aboutUsTitle => 'About Asim - Your Afghanistan eSIM Specialist';
  
  @override
  String get ourMission => 'Our Mission';
  
  @override
  String get ourMissionDesc => 'To provide seamless, reliable, and affordable eSIM connectivity solutions specifically designed for travelers and residents in Afghanistan.';
  
  @override
  String get pioneering => 'Pioneering Afghanistan Connectivity';
  
  @override
  String get pioneeringDesc => 'Asim is proud to be the first eSIM provider dedicated exclusively to Afghanistan. We understand the unique connectivity challenges in the region and have developed specialized solutions to keep you connected wherever your journey takes you.';
  
  @override
  String get whyChooseUs => 'Why Choose Asim?';
  
  @override
  String get dedicatedToAfghanistan => 'Dedicated to Afghanistan';
  
  @override
  String get dedicatedToAfghanistanDesc => 'Unlike other providers, we focus exclusively on Afghanistan, ensuring optimal network partnerships and coverage specifically for this region.';
  
  @override
  String get instantConnectivity => 'Instant Connectivity';
  
  @override
  String get instantConnectivityDesc => 'Get connected within minutes of purchase. No waiting, no physical SIM cards, no hassle.';
  
  @override
  String get reliableNetwork => 'Reliable Network';
  
  @override
  String get reliableNetworkDesc => 'We partner with the best local network operators to ensure stable and fast connectivity across Afghanistan.';
  
  @override
  String get affordableRates => 'Affordable Rates';
  
  @override
  String get affordableRatesDesc => 'Competitive pricing designed specifically for the Afghanistan market, offering the best value for your money.';
  
  @override
  String get localSupport => 'Local Support';
  
  @override
  String get localSupportDesc => 'Our support team understands the local context and can assist you in English, Dari, and Pashto.';
  
  @override
  String get ourVision => 'Our Vision';
  
  @override
  String get ourVisionDesc => 'To bridge the digital divide in Afghanistan by making reliable internet connectivity accessible to everyone, whether you\'re visiting for business, travel, or connecting with family.';
  
  @override
  String get getConnected => 'Get Connected Today';
  
  @override
  String get firstEsimProvider => 'The First eSIM Provider for Afghanistan';
  
  @override
  String get joinThousands => 'Join thousands of satisfied customers who trust Asim for their Afghanistan connectivity needs.';
  
  @override
  String get trustedByTravelers => 'Trusted by Travelers & Locals';
  
  @override
  String get backToHome => 'Back to Home';
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
  
  // Terms and Conditions
  @override
  String get termsAndConditions => 'Terms & Conditions';
  
  @override
  String get termsAndConditionsTitle => 'Terms and Conditions';
  
  // About Us page
  @override
  String get aboutUsTitle => 'درباره آسیم - متخصص ای‌سیم افغانستان';
  
  @override
  String get ourMission => 'مأموریت ما';
  
  @override
  String get ourMissionDesc => 'ارائه راه‌حل‌های ارتباطی ای‌سیم یکپارچه، قابل اعتماد و مقرون به صرفه که به طور خاص برای مسافران و ساکنان افغانستان طراحی شده است.';
  
  @override
  String get pioneering => 'پیشگام در ارتباطات افغانستان';
  
  @override
  String get pioneeringDesc => 'آسیم مفتخر است که اولین ارائه‌دهنده ای‌سیم است که به طور انحصاری به افغانستان اختصاص یافته است. ما چالش‌های منحصر به فرد ارتباطی در منطقه را درک می‌کنیم و راه‌حل‌های تخصصی برای حفظ ارتباط شما در هر کجا که سفر می‌کنید توسعه داده‌ایم.';
  
  @override
  String get whyChooseUs => 'چرا آسیم را انتخاب کنید؟';
  
  @override
  String get dedicatedToAfghanistan => 'اختصاص به افغانستان';
  
  @override
  String get dedicatedToAfghanistanDesc => 'برخلاف سایر ارائه‌دهندگان، ما به طور انحصاری بر افغانستان تمرکز می‌کنیم و شراکت‌های شبکه و پوشش بهینه را به طور خاص برای این منطقه تضمین می‌کنیم.';
  
  @override
  String get instantConnectivity => 'ارتباط فوری';
  
  @override
  String get instantConnectivityDesc => 'در عرض چند دقیقه پس از خرید متصل شوید. بدون انتظار، بدون سیم فیزیکی، بدون دردسر.';
  
  @override
  String get reliableNetwork => 'شبکه قابل اعتماد';
  
  @override
  String get reliableNetworkDesc => 'ما با بهترین اپراتورهای شبکه محلی شراکت می‌کنیم تا ارتباط پایدار و سریع در سراسر افغانستان را تضمین کنیم.';
  
  @override
  String get affordableRates => 'نرخ‌های مقرون به صرفه';
  
  @override
  String get affordableRatesDesc => 'قیمت‌گذاری رقابتی که به طور خاص برای بازار افغانستان طراحی شده و بهترین ارزش را برای پول شما ارائه می‌دهد.';
  
  @override
  String get localSupport => 'پشتیبانی محلی';
  
  @override
  String get localSupportDesc => 'تیم پشتیبانی ما زمینه محلی را درک می‌کند و می‌تواند به انگلیسی، دری و پشتو به شما کمک کند.';
  
  @override
  String get ourVision => 'دیدگاه ما';
  
  @override
  String get ourVisionDesc => 'پل زدن بر شکاف دیجیتال در افغانستان با در دسترس قرار دادن ارتباط اینترنتی قابل اعتماد برای همه، چه برای کسب‌وکار، سفر یا ارتباط با خانواده باشد.';
  
  @override
  String get getConnected => 'همین امروز متصل شوید';
  
  @override
  String get firstEsimProvider => 'اولین ارائه‌دهنده ای‌سیم برای افغانستان';
  
  @override
  String get joinThousands => 'به هزاران مشتری راضی بپیوندید که برای نیازهای ارتباطی افغانستان خود به آسیم اعتماد می‌کنند.';
  
  @override
  String get trustedByTravelers => 'مورد اعتماد مسافران و مردم محلی';
  
  @override
  String get backToHome => 'بازگشت به خانه';
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
  
  // Terms and Conditions
  @override
  String get termsAndConditions => 'Terms & Conditions';
  
  @override
  String get termsAndConditionsTitle => 'Terms and Conditions';
  
  // About Us page
  @override
  String get aboutUsTitle => 'د آسیم په اړه - ستاسو د افغانستان ای‌سیم متخصص';
  
  @override
  String get ourMission => 'زموږ ماموریت';
  
  @override
  String get ourMissionDesc => 'د افغانستان د مسافرینو او اوسیدونکو لپاره ډیزاین شوي یوځای، د اعتماد وړ او د لاسرسي وړ ای‌سیم اړیکو حلونه چمتو کول.';
  
  @override
  String get pioneering => 'د افغانستان اړیکو کې مخکښ';
  
  @override
  String get pioneeringDesc => 'آسیم په دې ویاړي چې د افغانستان لپاره لومړۍ ای‌سیم وړاندې کوونکی دی چې په ځانګړي توګه افغانستان ته وقف دی. موږ په سیمه کې د اړیکو ځانګړي ننګونې پوهیږو او ځانګړي حلونه موږ رامینځته کړي ترڅو تاسو په هر ځای کې چې سفر کوئ وصل وساتو.';
  
  @override
  String get whyChooseUs => 'ولې آسیم وټاکئ؟';
  
  @override
  String get dedicatedToAfghanistan => 'د افغانستان لپاره وقف';
  
  @override
  String get dedicatedToAfghanistanDesc => 'د نورو وړاندې کوونکو په پرتله، موږ په ځانګړي توګه افغانستان ته پاملرنه کوو، د دې سیمې لپاره په ځانګړي توګه د شبکې غوره ملګرتیاوې او پوښښ تضمینوو.';
  
  @override
  String get instantConnectivity => 'سمدستي اړیکه';
  
  @override
  String get instantConnectivityDesc => 'د پیرودلو څخه په څو دقیقو کې وصل شئ. هیڅ انتظار نشته، هیڅ فزیکي سیم نشته، هیڅ ستونزه نشته.';
  
  @override
  String get reliableNetwork => 'د اعتماد وړ شبکه';
  
  @override
  String get reliableNetworkDesc => 'موږ د غوره محلي شبکې چلوونکو سره ملګرتیا کوو ترڅو په ټول افغانستان کې مستحکم او ګړندي اړیکه تضمین کړو.';
  
  @override
  String get affordableRates => 'د لاسرسي وړ نرخونه';
  
  @override
  String get affordableRatesDesc => 'د افغانستان د بازار لپاره په ځانګړي توګه ډیزاین شوي رقابتي نرخونه، ستاسو د پیسو لپاره غوره ارزښت وړاندې کوي.';
  
  @override
  String get localSupport => 'محلي ملاتړ';
  
  @override
  String get localSupportDesc => 'زموږ د ملاتړ ټیم محلي شرایط پوهیږي او کولی شي په انګلیسي، دري او پښتو کې ستاسو سره مرسته وکړي.';
  
  @override
  String get ourVision => 'زموږ لیدنه';
  
  @override
  String get ourVisionDesc => 'په افغانستان کې د ډیجیټل تشې د پورته کولو لپاره د اعتماد وړ انټرنټ اړیکه د ټولو لپاره د لاسرسي وړ کول، که دا د سوداګرۍ، سفر یا د کورنۍ سره د اړیکو لپاره وي.';
  
  @override
  String get getConnected => 'نن ورځ وصل شئ';
  
  @override
  String get firstEsimProvider => 'د افغانستان لپاره لومړۍ ای‌سیم وړاندې کوونکی';
  
  @override
  String get joinThousands => 'د زرګونو راضي پیرودونکو سره یوځای شئ چې د افغانستان د اړیکو اړتیاو لپاره آسیم ته اعتماد کوي.';
  
  @override
  String get trustedByTravelers => 'د مسافرینو او محلي خلکو لخوا د اعتماد وړ';
  
  @override
  String get backToHome => 'کور ته بیرته';
}
