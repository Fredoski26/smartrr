import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';
import 'package:smartrr/components/screens/general/forgot_password.dart';
import 'package:smartrr/components/screens/org/org_cases_screen.dart';
import 'package:smartrr/components/screens/org/refer_or_cases_page.dart';
import 'package:smartrr/components/screens/org/referal_page.dart';
import 'package:smartrr/components/screens/user/cases_history_screen.dart';
import 'package:smartrr/components/screens/org/org_sign_up_page.dart';
import 'package:smartrr/components/screens/user/sign_up_page.dart';
import 'package:smartrr/utils/utils.dart';
import 'components/screens/general/login_page.dart';
import 'components/screens/user/report_or_history_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Splash(),
        '/login': (context) => LoginPage(),
        '/userSignup': (context) => SignUpPage(),
        '/orgSignup': (context) => OrgSignUpPage(),
        '/casesHistory': (context) => CasesHistoryScreen(),
        '/userMain': (context) => ReportOrHistoryPage(),
        '/orgMain': (context) => ReferOrCasesPage(),
        '/refer': (context) => ReferralPage(),
        '/forgot': (context) => ForgotPasswordScreen(),
      },
      theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          primarySwatch: Colors.orange,
          appBarTheme: AppBarTheme(
              centerTitle: true,
              titleTextStyle:
                  TextStyle().copyWith(color: Colors.white, fontSize: 18),
              iconTheme: IconThemeData().copyWith(color: Colors.white))),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  PackageInfo packageInfo;

  @override
  void initState() {
    super.initState();
    _next();
    _getVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 4),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/background.png'), fit: BoxFit.cover),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Image.asset(
                    'assets/icons/LOGO.png',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Smart rr'.toUpperCase(),
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  packageInfo == null ? '' : 'ver ${packageInfo.version}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _next() async {
    User currentUser = await FirebaseAuth.instance.currentUser;
    bool isUser = await getIsUserPref();
    debugPrint("Current User is: $currentUser");
    Future.delayed(Duration(seconds: 1)).then((value) async {
      if (currentUser != null) {
        if (currentUser.email == null) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', ModalRoute.withName('Login'));
        } else {
          if (isUser == null) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/login', ModalRoute.withName('Login'));
          } else if (isUser) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/userMain', ModalRoute.withName('Dashboard'));
          } else {
            Navigator.pushNamedAndRemoveUntil(
                context, '/orgMain', ModalRoute.withName('Dashboard'));
          }
        }
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, '/login', ModalRoute.withName('Login'));
      }
    });
  }

  Future _getVersion() async {
    packageInfo = await PackageInfo.fromPlatform();
  }
}
