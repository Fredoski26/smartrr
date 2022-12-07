import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
import 'package:smartrr/components/screens/user/sign_up_page.dart';
import 'package:smartrr/components/wrapper.dart';
import 'package:smartrr/generated/l10n.dart';
import 'package:smartrr/provider/language_provider.dart';
import 'package:smartrr/theme/themes.dart';
import 'package:smartrr/utils/colors.dart';
import 'components/screens/general/login_page.dart';
import 'components/screens/user/report_or_history_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ChangeNotifierProvider(create: (context) => LanguageNotifier())
    ],
    child: Consumer<ThemeNotifier>(
      builder: (context, ThemeNotifier notifier, child) =>
          AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle().copyWith(
            statusBarColor: primaryColor,
            statusBarIconBrightness: Brightness.light),
        child: MyApp(
          isDarkTheme: notifier.darkTheme,
        ),
      ),
    ),
  ));
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
        '/userMain': (context) => ReportOrHistoryPage(),
        '/orgMain': (context) => ReferOrCasesPage(),
        '/refer': (context) => ReferralPage(),
        '/forgot': (context) => ForgotPasswordScreen(),
        '/settings': ((context) => Settings()),
        '/about': (context) => About(),
        '/faq': (context) => FrequentlyAskedQuestions(),
        "/countries": (context) => SelectCountry(),
        "/srhr": (ontext) => AllAboutSRHR()
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
