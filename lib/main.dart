import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smartrr/components/screens/main_wrapper.dart';
import 'package:smartrr/components/screens/period_tracker/period_tracker_wrapper.dart';
import 'package:smartrr/components/screens/shop/shopping_cart.dart';
import 'package:smartrr/components/screens/user/about.dart';
import 'package:smartrr/components/screens/user/all_about_srhr.dart';
import 'package:smartrr/components/screens/user/faq.dart';
import 'package:smartrr/components/screens/general/forgot_password.dart';
import 'package:smartrr/components/screens/org/refer_or_cases_page.dart';
import 'package:smartrr/components/screens/org/referal_page.dart';
import 'package:smartrr/components/screens/user/select_country.dart';
import 'package:smartrr/components/screens/user/settings.dart';
import 'package:smartrr/components/screens/user/cases_history_screen.dart';
import 'package:smartrr/components/screens/org/org_sign_up_page.dart';
import 'package:smartrr/components/screens/shop/shop.dart';
import 'package:smartrr/components/screens/user/sign_up_page.dart';
import 'package:smartrr/components/auth_wrapper.dart';
import 'package:smartrr/generated/l10n.dart';
import 'package:smartrr/provider/language_provider.dart';
import 'package:smartrr/services/local_notification_service.dart';
import 'package:smartrr/services/push_notification_service.dart';
import 'package:smartrr/theme/themes.dart';
import 'components/screens/general/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:smartrr/models/product.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:smartrr/env/env.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class DownloadHandler {
  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) {
    final SendPort sendPort =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;

    sendPort.send([id, status.value, progress]);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize flutter firebase library
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();

  // initialize flutter hive database
  await Hive.initFlutter();
// register hive database adapters
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(ProductTypeAdapter());
  Hive.registerAdapter(ProductItemAdapter());
  Hive.registerAdapter(ProductImageAdapter());
//  open boxs
  await Hive.openBox("messages");
  await Hive.openBox("period_tracker");
  await Hive.openBox("notifications");
  await Hive.openBox("config");
  await Hive.openBox<Product>("cart");

  await LocalNotificationService.initialize();
  await PushNotificationService.initialize();

  // Initialize flutter downloader plugin for courses
  await FlutterDownloader.initialize(debug: true);
  await FlutterDownloader.registerCallback(DownloadHandler.downloadCallback);

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await SentryFlutter.init(
    (options) {
      options.dsn = Env.sentryDsn;
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeNotifier()),
          ChangeNotifierProvider(create: (context) => LanguageNotifier())
        ],
        child: Consumer<ThemeNotifier>(
          builder: (context, ThemeNotifier notifier, child) => MyApp(
            isDarkTheme: notifier.darkTheme,
          ),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isDarkTheme;

  MyApp({this.isDarkTheme = false});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => AuthWrapper(),
        '/login': (context) => LoginPage(),
        '/userSignup': (context) => SignUpPage(),
        '/orgSignup': (context) => OrgSignUpPage(),
        '/casesHistory': (context) => CasesHistoryScreen(),
        '/userMain': (context) => MainWrapper(),
        '/orgMain': (context) => ReferOrCasesPage(),
        '/refer': (context) => ReferralPage(),
        '/forgot': (context) => ForgotPasswordScreen(),
        '/settings': ((context) => Settings()),
        '/about': (context) => About(),
        '/faq': (context) => FrequentlyAskedQuestions(),
        "/countries": (context) => SelectCountry(),
        "/srhr": (context) => AllAboutSRHR(),
        "/shop": (context) => Shop(),
        "/cart": (context) => ShoppingCart(),
        "/periodTracker": (context) => PeriodTrackerWrapper()
      },
      theme: isDarkTheme ? darkTheme : appTheme,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }
}
