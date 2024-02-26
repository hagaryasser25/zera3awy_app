import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:zera3awy_app/auth/login_page.dart';
import 'package:zera3awy_app/company/company_feeds.dart';
import 'package:zera3awy_app/models/users_model.dart';
import 'package:zera3awy_app/user/user_cart.dart';
import 'package:zera3awy_app/user/user_farms.dart';
import 'package:zera3awy_app/user/user_list.dart';

class UserHome extends StatefulWidget {
  static const routeName = '/userHome';

  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
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
                  ),
                  drawer: Drawer(
                    child: FutureBuilder(
                      future: getUserData(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (currentUser == null) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView(
                            // Important: Remove any padding from the ListView.
                            padding: EdgeInsets.zero,
                            children: [
                              DrawerHeader(
                                decoration: BoxDecoration(
                                  color: HexColor('#2dda9f'),
                                ),
                                child: Column(
                                  children: [
                                    Center(
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: AssetImage(
                                            'assets/images/logo.jpg'),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text("معلومات المستخدم",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white)),
                                  ],
                                ),
                              ),
                              Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      splashColor:
                                          Theme.of(context).splashColor,
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.popAndPushNamed(
                                              context, UserCart.routeName);
                                        },
                                        title: Text("سلة المشتريات"),
                                        leading: Icon(Icons.shopping_bag),
                                      ))),
                              Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      splashColor:
                                          Theme.of(context).splashColor,
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return UserList(
                                    name: '${currentUser.fullName}',
                                  );
                                }));
                                        },
                                        title: Text("مشترياتى"),
                                        leading: Icon(Icons.list_alt),
                                      ))),
                              Divider(
                                thickness: 0.8,
                                color: Colors.grey,
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.person,
                                ),
                                title: const Text('اسم المستخدم'),
                                subtitle: Text('${currentUser.fullName}'),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.email,
                                ),
                                title: const Text('البريد الالكترونى'),
                                subtitle: Text('${currentUser.email}'),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.phone,
                                ),
                                title: const Text('رقم الهاتف'),
                                subtitle: Text('${currentUser.phoneNumber}'),
                              ),
                              Divider(
                                thickness: 0.8,
                                color: Colors.grey,
                              ),
                              Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      splashColor:
                                          Theme.of(context).splashColor,
                                      child: ListTile(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text('تأكيد'),
                                                  content: Text(
                                                      'هل انت متأكد من تسجيل الخروج'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        FirebaseAuth.instance
                                                            .signOut();
                                                        Navigator.pushNamed(
                                                            context,
                                                            LoginPage
                                                                .routeName);
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
                                        title: Text('تسجيل الخروج'),
                                        leading:
                                            Icon(Icons.exit_to_app_rounded),
                                      )))
                            ],
                          );
                        }
                      },
                    ),
                  ),
                  body: Column(children: [
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
                                return UserFarms(
                                  userName: '${currentUser.fullName}',
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
                                    Image.asset('assets/images/farm.png',
                                        width: 120.w, height: 120.h),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        "المزارع",
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
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('تأكيد'),
                                      content:
                                          Text('هل انت متأكد من تسجيل الخروج'),
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
                                    Image.asset('assets/images/logout.png',
                                        width: 120.w, height: 120.h),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        "تسجيل الخروج",
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
                    )
                  ]),
                )));
  }
}
