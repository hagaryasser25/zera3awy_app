import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:zera3awy_app/farm/farm_home.dart';

import '../models/cart_model.dart';

class FarmCart extends StatefulWidget {
  static const routeName = '/farmCart';
  const FarmCart({super.key});

  @override
  State<FarmCart> createState() => _FarmCartState();
}

class _FarmCartState extends State<FarmCart> {
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  List<Cart> cartList = [];
  List<String> keyslist = [];
  int totalPrice = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchCart();
    total();
  }


  @override
  void fetchCart() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database
        .reference()
        .child("cart")
        .child(FirebaseAuth.instance.currentUser!.uid);
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      Cart p = Cart.fromJson(event.snapshot.value);
      cartList.add(p);
      keyslist.add(event.snapshot.key.toString());
      if (mounted) {
        setState(() {});
      }
    });
  }

  void total() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.
        reference()
        .child("cart")
        .child(FirebaseAuth.instance.currentUser!.uid);
    var snapshot = await base.get();
    for (var element in snapshot.children) {
      Cart model = Cart.fromJson(element.value);
      print('modelPrice: ${model.total}');

      setState(() {
        totalPrice += model.total!;
        print(totalPrice);
      });
    }
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
                  "سلة المشتريات",
                  style: TextStyle(color: Colors.white),
                ))),
          body: Column(
            children: [
              
              Expanded(
                flex: 8,
                child: ListView.builder(
                    itemCount: cartList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 15.w, left: 15.w),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, right: 15, left: 15, bottom: 10),
                                  child: Row(children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 10.w),
                                      child: Container(
                                        width: 150.w,
                                        child: Column(
                                          children: [
                                            Text(
                                              '${cartList[index].name.toString()}',
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              'اسم الشركة : ${cartList[index].companyName.toString()}',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: HexColor('#999999')),
                                            ),
                                            Text(
                                              'سعر المنتج : ${cartList[index].price.toString()}',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: HexColor('#999999')),
                                            ),
                                            Text(
                                              'الكمية : ${cartList[index].amount.toString()} ',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: HexColor('#999999')),
                                            ),
                                            Text(
                                              'الأجمالى : ${cartList[index].total.toString()}',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: HexColor('#999999')),
                                            ),
                                            ConstrainedBox(
                                              constraints:
                                                  BoxConstraints.tightFor(
                                                      width: 120.w,
                                                      height: 35.h),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color.fromARGB(
                                                      255, 71, 233, 133),
                                                ),
                                                child: Text('شراء الأن'),
                                                onPressed: () async {
                                                  /*
                                                  int? price =
                                                      cartList[index].price;
                                                  int? total =
                                                      cartList[index].total;
                                                  User? user = FirebaseAuth
                                                      .instance.currentUser;

                                                  if (user != null) {
                                                    String uid = user.uid;

                                                    DatabaseReference
                                                        companyRef =
                                                        FirebaseDatabase
                                                            .instance
                                                            .reference()
                                                            .child('bookings');

                                                    String? id =
                                                        companyRef.push().key;

                                                    await companyRef
                                                        .child(id!)
                                                        .set({
                                                      'id': id,
                                                      'name':
                                                          '${cartList[index].name.toString()}',
                                                      'price': price,
                                                      'amount':
                                                          '${cartList[index].amount.toString()}',
                                                      'total': total,
                                                      'imageUrl':
                                                          '${cartList[index].imageUrl.toString()}',
                                                      'companyName':
                                                          '${cartList[index].companyName.toString()}',
                                                      'userName':
                                                          '${cartList[index].userName.toString()}',
                                                      'userPhone':
                                                          '${cartList[index].userPhone.toString()}',
                                                    });
                                                  }

                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (context) =>
                                                              AlertDialog(
                                                                title: Text(
                                                                    'ادفع الأن'),
                                                                content:
                                                                    Container(
                                                                  height: 100.h,
                                                                  child: Text(
                                                                      'اختر طريقة الدفع'),
                                                                ),
                                                                actions: [
                                                                  ElevatedButton
                                                                      .icon(
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .credit_card,
                                                                        size:
                                                                            18),
                                                                    label: Text(
                                                                        'بطاقة الأئتمان'),
                                                                    onPressed:
                                                                        () {
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                Text("Notice"),
                                                                            content:
                                                                                SizedBox(
                                                                              height: 65.h,
                                                                              child: TextField(
                                                                                decoration: InputDecoration(
                                                                                  fillColor: HexColor('#155564'),
                                                                                  focusedBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(color: Color(0xfff8a55f), width: 2.0),
                                                                                  ),
                                                                                  border: OutlineInputBorder(),
                                                                                  hintText: 'ادخل رقم الفيزا',
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            actions: [
                                                                              TextButton(
                                                                                style: TextButton.styleFrom(
                                                                                  primary: HexColor('#6bbcba'),
                                                                                ),
                                                                                child: Text("دفع"),
                                                                                onPressed: () {
                                                                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => super.widget));
                                                                                  base.child(cartList[index].id.toString()).remove();
                                                                                  Navigator.pushNamed(context, FarmHome.routeName);
                                                                                },
                                                                              )
                                                                            ],
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                                  ElevatedButton
                                                                      .icon(
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .credit_card,
                                                                        size:
                                                                            18),
                                                                    label: Text(
                                                                        'كاش'),
                                                                    onPressed:
                                                                        () {
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                Text("Notice"),
                                                                            content:
                                                                                Text("تم الحجز وسيتم الدفع كاش فى المركز"),
                                                                            actions: [
                                                                              TextButton(
                                                                                style: TextButton.styleFrom(
                                                                                  primary: HexColor('#6bbcba'),
                                                                                ),
                                                                                child: Text("Ok"),
                                                                                onPressed: () {
                                                                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => super.widget));
                                                                                  base.child(cartList[index].id.toString()).remove();
                                                                                  Navigator.pushNamed(context, FarmHome.routeName);
                                                                                },
                                                                              )
                                                                            ],
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ));
                                                              */
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.w,
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                            width: 110.w,
                                            height: 170.h,
                                            child: Image.network(
                                                '${cartList[index].imageUrl.toString()}')),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        super.widget));
                                            base
                                                .child(cartList[index]
                                                    .id
                                                    .toString())
                                                .remove();
                                          },
                                          child: Icon(Icons.delete,
                                              color: Color.fromARGB(
                                                  255, 122, 122, 122)),
                                        )
                                      ],
                                    ),
                                  ]),
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
