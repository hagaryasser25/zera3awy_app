import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zera3awy_app/auth/company_login.dart';
import 'package:zera3awy_app/auth/farm_login.dart';
import 'package:zera3awy_app/auth/login_page.dart';
import 'package:zera3awy_app/auth/signup_page.dart';
import 'package:zera3awy_app/company/company_feeds.dart';
import 'package:zera3awy_app/company/company_home.dart';
import 'package:zera3awy_app/farm/farm_cart.dart';
import 'package:zera3awy_app/farm/farm_home.dart';
import 'package:zera3awy_app/user/user_cart.dart';
import 'package:zera3awy_app/user/user_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FirebaseAuth.instance.currentUser == null
          ? LoginPage()
          : FirebaseAuth.instance.currentUser!.displayName == 'مزرعة'
              ? const FarmHome()
              : FirebaseAuth.instance.currentUser!.displayName == "شركة اسمدة"
                  ? const CompanyHome()
                  : UserHome(),
      routes: {
        UserHome.routeName: (ctx) => UserHome(),
        CompanyHome.routeName: (ctx) => CompanyHome(),
        FarmHome.routeName: (ctx) => FarmHome(),
        CompanyLogin.routeName: (ctx) => CompanyLogin(),
        FarmLogin.routeName: (ctx) => FarmLogin(),
        FarmCart.routeName: (ctx) => FarmCart(),
        UserCart.routeName: (ctx) => UserCart(),
        SignUpPage.routeName: (ctx) => SignUpPage(),
        LoginPage.routeName: (ctx) => LoginPage(),
      },
    );
  }
}
