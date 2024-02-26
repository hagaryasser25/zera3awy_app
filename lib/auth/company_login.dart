import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:zera3awy_app/auth/signup_page.dart';
import 'package:zera3awy_app/company/company_home.dart';
import 'package:zera3awy_app/user/user_home.dart';

class CompanyLogin extends StatefulWidget {
  static const routeName = '/companyLogin';
  const CompanyLogin({super.key});

  @override
  State<CompanyLogin> createState() => _CompanyLoginState();
}

class _CompanyLoginState extends State<CompanyLogin> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => Scaffold(
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 100.h),
                child: Center(
                    child: Image.asset(
                  "assets/images/logo.jpg",
                  height: 150.h,
                  width: 150.w,
                )),
              ),
              Text(
                "زرعاوى",
                style: TextStyle(
                    color: HexColor("#2dda9f"),
                    fontFamily: 'Lemonada',
                    fontSize: 20),
              ),
              SizedBox(
                height: 30.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "تسجيل دخول",
                    style: TextStyle(
                      color: HexColor("#2dda9f"),
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Padding(
                padding: EdgeInsets.only(right: 10.w, left: 10.w),
                child: SizedBox(
                  height: 65.h,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: HexColor('#2dda9f'), width: 2.0),
                      ),
                      border: OutlineInputBorder(),
                      hintText: 'البريد الألكترونى',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Padding(
                padding: EdgeInsets.only(right: 10.w, left: 10.w),
                child: SizedBox(
                  height: 65.h,
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: HexColor('#2dda9f'), width: 2.0),
                      ),
                      border: OutlineInputBorder(),
                      hintText: 'كلمة المرور',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Padding(
                padding: EdgeInsets.only(right: 10.w, left: 10.w),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                      width: double.infinity, height: 65.h),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: HexColor("#2dda9f"),
                    ),
                    child: Text(
                      'تسجيل الدخول',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      var email = emailController.text.trim();
                      var password = passwordController.text.trim();

                      if (email.isEmpty || password.isEmpty) {
                        MotionToast(
                                primaryColor: Colors.blue,
                                width: 300,
                                height: 50,
                                position: MotionToastPosition.center,
                                description: Text("please fill all fields"))
                            .show(context);

                        return;
                      }
                      ProgressDialog progressDialog = ProgressDialog(context,
                          title: Text('Logging In'),
                          message: Text('Please Wait'));
                      progressDialog.show();

                      try {
                        FirebaseAuth auth = FirebaseAuth.instance;
                        UserCredential userCredential =
                            await auth.signInWithEmailAndPassword(
                                email: email, password: password);

                        if (userCredential.user != null) {
                          progressDialog.dismiss();
                          Navigator.pushReplacementNamed(context, CompanyHome.routeName);
                        }
                      } on FirebaseAuthException catch (e) {
                        progressDialog.dismiss();
                        if (e.code == 'user-not-found') {
                          MotionToast(
                                  primaryColor: Colors.blue,
                                  width: 300,
                                  height: 50,
                                  position: MotionToastPosition.center,
                                  description: Text("user not found"))
                              .show(context);
                          return;
                        } else if (e.code == 'wrong-password') {
                          MotionToast(
                                  primaryColor: Colors.blue,
                                  width: 300,
                                  height: 50,
                                  position: MotionToastPosition.center,
                                  description: Text("wrong email or password"))
                              .show(context);

                          return;
                        }
                      } catch (e) {
                        MotionToast(
                                primaryColor: Colors.blue,
                                width: 300,
                                height: 50,
                                position: MotionToastPosition.center,
                                description: Text("something went wrong"))
                            .show(context);
                        print(e);

                        progressDialog.dismiss();
                      }
                    },
                  ),
                ),
              ),

              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SignUpPage.routeName);
                  },
                  child: Text(
                    'انشاء حساب',
                    style: TextStyle(color: HexColor("#5b5b5b")),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
