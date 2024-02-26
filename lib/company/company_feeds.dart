import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:zera3awy_app/auth/login_page.dart';
import 'package:zera3awy_app/company/add_feeds.dart';
import 'package:zera3awy_app/models/feeds_model.dart';
import 'package:zera3awy_app/models/users_model.dart';

class CompanyFeeds extends StatefulWidget {
  String companyName;
  static const routeName = '/companyFeeds';
  CompanyFeeds({required this.companyName});

  @override
  State<CompanyFeeds> createState() => _CompanyFeedsState();
}

class _CompanyFeedsState extends State<CompanyFeeds> {
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  List<Feeds> feedsList = [];
  List<String> keyslist = [];

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
              title: TextButton.icon(
                // Your icon here
                label: Text(
                  "أضافة اسمدة",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                icon: Align(
                    child: Icon(
                  Icons.add,
                  color: Colors.white,
                )), // Your text here
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AddFeeds(
                      companyName: '${widget.companyName}',
                    );
                  }));
                },
              ),
            ),
            body: ListView.builder(
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
                                child: Container(
                                  width: 130.w,
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
                                      Center(
                                        child: Text(
                                          '${feedsList[index].description.toString()}',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 19,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          super.widget));
                                          FirebaseDatabase.instance
                                              .reference()
                                              .child('feeds')
                                              .child('${widget.companyName}')
                                              .child('${feedsList[index].id}')
                                              .remove();
                                        },
                                        child: Icon(Icons.delete,
                                            color: Color.fromARGB(
                                                255, 122, 122, 122)),
                                      )
                                    ],
                                  ),
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
        ));
  }
}
