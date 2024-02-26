import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:zera3awy_app/auth/login_page.dart';
import 'package:zera3awy_app/company/add_feeds.dart';
import 'package:zera3awy_app/farm/add_product.dart';
import 'package:zera3awy_app/models/feeds_model.dart';
import 'package:zera3awy_app/models/products_model.dart';
import 'package:zera3awy_app/models/users_model.dart';

class FarmProducts extends StatefulWidget {
  String farmName;
  static const routeName = '/farmProducts';
  FarmProducts({required this.farmName});

  @override
  State<FarmProducts> createState() => _FarmProductsState();
}

class _FarmProductsState extends State<FarmProducts> {
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  List<Products> productsList = [];
  List<String> keyslist = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchProducts();
  }

  fetchProducts() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = await database
        .reference()
        .child("products")
        .child('${widget.farmName}');
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      Products p = Products.fromJson(event.snapshot.value);
      productsList.add(p);
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
                  "اضافة منتجات",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                icon: Align(
                    child: Icon(
                  Icons.add,
                  color: Colors.white,
                )), // Your text here
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AddProduct(
                      farmName: '${widget.farmName}',
                    );
                  }));
                },
              ),
            ),
            body: ListView.builder(
                itemCount: productsList.length,
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
                                              '${productsList[index].imageUrl.toString()}')),
                                      Text(
                                        '${productsList[index].name.toString()}',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'سعر المنتج : ${productsList[index].price.toString()}',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                                      Text(
                                        'الكمية المتاحة : ${productsList[index].amount.toString()} متر',
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
                                          '${productsList[index].description.toString()}',
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
                                              .child('products')
                                              .child('${widget.farmName}')
                                              .child('${productsList[index].id}')
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
