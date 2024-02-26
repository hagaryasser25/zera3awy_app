import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:zera3awy_app/farm/farm_home.dart';
import 'package:zera3awy_app/models/feeds_model.dart';

import '../models/users_model.dart';

class CompanyProducts extends StatefulWidget {
  String companyName;
  static const routeName = '/userMarble';
  CompanyProducts({required this.companyName});

  @override
  State<CompanyProducts> createState() => _CompanyProductsState();
}

class _CompanyProductsState extends State<CompanyProducts> {
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  List<Feeds> feedsList = [];
  List<String> keyslist = [];
  var amountController = TextEditingController();
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchFeeds();
  }

  fetchFeeds() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = await database
        .reference()
        .child("feeds")
        .child('${widget.companyName}');
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      Feeds p = Feeds.fromJson(event.snapshot.value);
      feedsList.add(p);
      keyslist.add(event.snapshot.key.toString());
      if (mounted) {
        setState(() {});
      }
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
                "المنتجات",
                style: TextStyle(color: Colors.white),
              ))),
          body: Column(
            children: [
              Expanded(
                flex: 8,
                child: ListView.builder(
                    itemCount: feedsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 15.w, left: 15.w),
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, right: 15, left: 15, bottom: 10),
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.w),
                                    child: Column(
                                      children: [
                                        Container(
                                            child: Image.network(
                                                '${feedsList[index].imageUrl.toString()}')),
                                        Text(
                                          '${feedsList[index].name.toString()}',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          'سعر المنتج : ${feedsList[index].price.toString()}',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                        Text(
                                          'الكمية المتاحة : ${feedsList[index].amount.toString()} متر',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Text(
                                          '${feedsList[index].description.toString()}',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 19,
                                          ),
                                        ),
                                        Center(
                                          child: InkWell(
                                            onTap: () async {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text("Notice"),
                                                    content: SizedBox(
                                                      height: 65.h,
                                                      child: TextField(
                                                        controller:
                                                            amountController,
                                                        decoration:
                                                            InputDecoration(
                                                          fillColor: HexColor(
                                                              '#155564'),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Color(
                                                                    0xfff8a55f),
                                                                width: 2.0),
                                                          ),
                                                          border:
                                                              OutlineInputBorder(),
                                                          hintText:
                                                              'ادخل الكمية',
                                                        ),
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                          primary: HexColor(
                                                              '#6bbcba'),
                                                        ),
                                                        child: Text("اضافة"),
                                                        onPressed: () async {
                                                          String name =
                                                              feedsList[index]
                                                                  .name
                                                                  .toString();
                                                          int? price =
                                                              feedsList[index]
                                                                  .price;
                                                          int amount = int.parse(
                                                              amountController
                                                                  .text
                                                                  .trim());
                                                          int total =
                                                              price! * amount;
                                                          String imageUrl =
                                                              feedsList[index]
                                                                  .imageUrl
                                                                  .toString();

                                                          if (amount == 0) {
                                                            MotionToast(
                                                                    primaryColor:
                                                                        Colors
                                                                            .blue,
                                                                    width: 300,
                                                                    height: 50,
                                                                    position:
                                                                        MotionToastPosition
                                                                            .center,
                                                                    description:
                                                                        Text(
                                                                            'ادخل الكمية'))
                                                                .show(context);
                                                            return;
                                                          }

                                                          User? user =
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser;

                                                          if (user != null) {
                                                            String uid =
                                                                user.uid;

                                                            DatabaseReference
                                                                companyRef =
                                                                FirebaseDatabase
                                                                    .instance
                                                                    .reference()
                                                                    .child(
                                                                        'cart')
                                                                    .child(uid);

                                                            String? id =
                                                                companyRef
                                                                    .push()
                                                                    .key;

                                                            await companyRef
                                                                .child(id!)
                                                                .set({
                                                              'id': id,
                                                              'name': name,
                                                              'price': price,
                                                              'amount': amount,
                                                              'total': total,
                                                              'imageUrl':
                                                                  imageUrl,
                                                              'companyName': widget
                                                                  .companyName,
                                                              'userName':
                                                                  currentUser
                                                                      .fullName,
                                                              'userPhone':
                                                                  currentUser
                                                                      .phoneNumber,
                                                            });
                                                            DatabaseReference
                                                                marbleRef =
                                                                FirebaseDatabase
                                                                    .instance
                                                                    .reference()
                                                                    .child(
                                                                        'feeds')
                                                                    .child(
                                                                        '${widget.companyName}')
                                                                    .child(
                                                                        '${feedsList[index].id}');

                                                            await marbleRef
                                                                .update({
                                                              'amount': feedsList[
                                                                          index]
                                                                      .amount! -
                                                                  amount,
                                                            });
                                                          }

                                                          showAlertDialog(
                                                              context);
                                                          Navigator.pushNamed(
                                                              context,
                                                              FarmHome
                                                                  .routeName);
                                                        },
                                                      )
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Icon(Icons.shopping_cart,
                                                color: Color.fromARGB(
                                                    255, 122, 122, 122)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          )
                        ],
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showAlertDialog(BuildContext context) {
  Widget remindButton = TextButton(
    style: TextButton.styleFrom(
      primary: HexColor('#6bbcba'),
    ),
    child: Text("Ok"),
    onPressed: () {
      Navigator.pushNamed(context, FarmHome.routeName);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Notice"),
    content: Text("تم الأضافة فى سلة المشتريات"),
    actions: [
      remindButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
