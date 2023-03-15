import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
import 'package:smartrr/components/wrapper.dart';
import 'package:smartrr/generated/l10n.dart';
import 'package:smartrr/provider/language_provider.dart';
import 'package:smartrr/services/local_notification_service.dart';
import 'package:smartrr/theme/themes.dart';
import 'components/screens/general/login_page.dart';
import 'components/screens/user/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:smartrr/models/product.dart';

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
  await Hive.openBox("cart");

  await LocalNotificationService.initialize();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
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
        '/': (context) => Wrapper(isDarkTheme: isDarkTheme),
        '/login': (context) => LoginPage(
              isDarkTheme: isDarkTheme,
            ),
        '/userSignup': (context) => SignUpPage(),
        '/orgSignup': (context) => OrgSignUpPage(),
        '/casesHistory': (context) => CasesHistoryScreen(),
        '/userMain': (context) => Home(),
        '/orgMain': (context) => ReferOrCasesPage(),
        '/refer': (context) => ReferralPage(),
        '/forgot': (context) => ForgotPasswordScreen(),
        '/settings': ((context) => Settings()),
        '/about': (context) => About(),
        '/faq': (context) => FrequentlyAskedQuestions(),
        "/countries": (context) => SelectCountry(),
        "/srhr": (context) => AllAboutSRHR(),
        "/shop": (context) => Shop(),
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
