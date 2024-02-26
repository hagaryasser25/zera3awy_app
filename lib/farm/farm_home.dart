import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:zera3awy_app/auth/login_page.dart';
import 'package:zera3awy_app/company/company_feeds.dart';
import 'package:zera3awy_app/farm/farm_cart.dart';
import 'package:zera3awy_app/farm/farm_company.dart';
import 'package:zera3awy_app/farm/farm_list.dart';
import 'package:zera3awy_app/farm/farm_products.dart';
import 'package:zera3awy_app/models/users_model.dart';

class FarmHome extends StatefulWidget {
  static const routeName = '/farmHome';

  const FarmHome({super.key});

  @override
  State<FarmHome> createState() => _FarmHomeState();
}

class _FarmHomeState extends State<FarmHome> {
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  late Users currentUser;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database
        .reference()
        .child("users")
        .child(FirebaseAuth.instance.currentUser!.uid);

    final snapshot = await base.get();
    setState(() {
      currentUser = Users.fromSnapshot(snapshot);
      print(currentUser.fullName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (context, child) => Scaffold(
                  appBar: AppBar(
                    iconTheme: IconThemeData(
                      color: Colors.white, //change your color here
                    ),
                    backgroundColor: HexColor('#2dda9f'),
                    title: Center(
                        child: Text(
                      "الصفحة الرئيسية",
                      style: TextStyle(color: Colors.white),
                    )),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.logout),
                        tooltip: 'Open shopping cart',
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('تأكيد'),
                                  content: Text('هل انت متأكد من تسجيل الخروج'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        FirebaseAuth.instance.signOut();
                                        Navigator.pushNamed(
                                            context, LoginPage.routeName);
                                      },
                                      child: Text('نعم'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('لا'),
                                    ),
                                  ],
                                );
                              });
                        },
                      ),
                    ],
                  ),
                  body: SingleChildScrollView(
                    child: Column(children: [
                      Image.asset("assets/images/company.jpg"),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        'الخدمات المتاحة',
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Lemonada',
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20.w),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return FarmCompany(
                                    farmName: '${currentUser.fullName}',
                                  );
                                }));
                              },
                              child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(right: 10.w, left: 10.w),
                                  child: Center(
                                    child: Column(children: [
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Image.asset('assets/images/seeds.png',
                                          width: 120.w, height: 120.h),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          "شركات الأسمدة",
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 30.w,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return FarmList(
                                    name: '${currentUser.fullName}',
                                  );
                                }));
                              },
                              child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(right: 10.w, left: 10.w),
                                  child: Center(
                                    child: Column(children: [
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Image.asset('assets/images/reserve.png',
                                          width: 120.w, height: 120.h),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          "طلبات الشراء",
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20.w),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return FarmProducts(
                                    farmName: '${currentUser.fullName}',
                                  );
                                }));
                              },
                              child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(right: 10.w, left: 10.w),
                                  child: Center(
                                    child: Column(children: [
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Image.asset('assets/images/veg.png',
                                          width: 120.w, height: 120.h),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          "أضافة منتجات",
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 30.w,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, FarmCart.routeName);
                              },
                              child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(right: 10.w, left: 10.w),
                                  child: Center(
                                    child: Column(children: [
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Image.asset('assets/images/cart.jpg',
                                          width: 120.w, height: 120.h),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          "سلة المشتريات",
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                    ]),
                  ),
                )));
  }
}
