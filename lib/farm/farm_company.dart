import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:zera3awy_app/auth/login_page.dart';
import 'package:zera3awy_app/company/add_feeds.dart';
import 'package:zera3awy_app/farm/company_products.dart';
import 'package:zera3awy_app/models/feeds_model.dart';
import 'package:zera3awy_app/models/users_model.dart';

class FarmCompany extends StatefulWidget {
  String farmName;
  static const routeName = '/farmCompany';
  FarmCompany({required this.farmName});

  @override
  State<FarmCompany> createState() => _FarmCompanyState();
}

class _FarmCompanyState extends State<FarmCompany> {
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
    base = await database.reference().child("feeds");
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
                  "شركات الاسمدة",
                  style: TextStyle(color: Colors.white),
                ))),
            body: ListView(
              scrollDirection: Axis.vertical,
              children: [
                Container(
                  child: StaggeredGridView.countBuilder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(
                      left: 15.w,
                      right: 15.w,
                      bottom: 15.h,
                    ),
                    crossAxisCount: 6,
                    itemCount: keyslist.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(right: 10.w, left: 10.w),
                            child: Center(
                              child: Column(children: [
                                SizedBox(
                                  height: 10.h,
                                ),
                                Image.asset('assets/images/company2.jpg',
                                    width: 155.w, height: 155.h),
                                     SizedBox(
                                  height: 10.h,
                                ),
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    '${keyslist[index]}',
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                ),
                                 SizedBox(
                                  height: 10.h,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32.0),
                                    ),
                                    padding: const EdgeInsets.all(0.0),
                                    elevation: 5,
                                  ),
                                  onPressed: () async {
                                    
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return CompanyProducts(
                                        companyName: '${keyslist[index]}',
                                      );
                                    }));
                                    
                                  },
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Color(0xff1bccba),
                                        Color(0xff22e2ab)
                                      ]),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      constraints:
                                          const BoxConstraints(minWidth: 88.0),
                                      child: const Text("المنتجات",style: TextStyle(
                                        color: Colors.white
                                      ),
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ),
                      );
                    },
                    staggeredTileBuilder: (int index) =>
                        new StaggeredTile.count(3, index.isEven ? 3 : 3),
                    mainAxisSpacing: 40.0,
                    crossAxisSpacing: 5.0.w,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
