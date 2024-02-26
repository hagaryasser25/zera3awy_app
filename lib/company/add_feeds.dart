import 'dart:io';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zera3awy_app/company/company_home.dart';

class AddFeeds extends StatefulWidget {
  String companyName;

  AddFeeds({required this.companyName});

  @override
  State<AddFeeds> createState() => _AddFeedsState();
}

class _AddFeedsState extends State<AddFeeds> {
  String imageUrl = '';
  File? image;
  var nameController = TextEditingController();
  var priceController = TextEditingController();
  var amountController = TextEditingController();
  var descriptionController = TextEditingController();

  @override
  Future pickImageFromDevice() async {
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile == null) return;
    final tempImage = File(xFile.path);
    setState(() {
      image = tempImage;
      print(image!.path);
    });

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference refrenceImageToUpload = referenceDirImages.child(uniqueFileName);
    try {
      await refrenceImageToUpload.putFile(File(xFile.path));

      imageUrl = await refrenceImageToUpload.getDownloadURL();
    } catch (error) {}
    print(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) => Scaffold(
            body: Padding(
              padding: EdgeInsets.only(
                top: 40.h,
              ),
              child: Padding(
                padding: EdgeInsets.only(right: 10.w, left: 10.w),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 30, horizontal: 30),
                                  child: CircleAvatar(
                                    radius: 65,
                                    backgroundColor: Color.fromARGB(255, 241, 240, 240),
                                    backgroundImage: image == null
                                        ? null
                                        : FileImage(image!),
                                  )),
                              Positioned(
                                  top: 120,
                                  left: 120,
                                  child: SizedBox(
                                    width: 50,
                                    child: RawMaterialButton(
                                        // constraints: BoxConstraints.tight(const Size(45, 45)),
                                        elevation: 10,
                                        fillColor: HexColor("#2dda9f"),
                                        child: const Align(
                                            // ignore: unnecessary_const
                                            child: Icon(Icons.add_a_photo,
                                                color: Colors.white, size: 22)),
                                        padding: const EdgeInsets.all(15),
                                        shape: const CircleBorder(),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Choose option',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: HexColor("#2dda9f"))),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: [
                                                        InkWell(
                                                            onTap: () {
                                                              pickImageFromDevice();
                                                            },
                                                            splashColor:
                                                                HexColor(
                                                                    '#FA8072'),
                                                            child: Row(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child: Icon(
                                                                      Icons
                                                                          .image,
                                                                      color: HexColor(
                                                                          '#6bbcba')),
                                                                ),
                                                                Text('Gallery',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ))
                                                              ],
                                                            )),
                                                        InkWell(
                                                            onTap: () {
                                                              // pickImageFromCamera();
                                                            },
                                                            splashColor:
                                                                HexColor(
                                                                    '#FA8072'),
                                                            child: Row(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child: Icon(
                                                                      Icons
                                                                          .camera,
                                                                      color: HexColor(
                                                                          '#6bbcba')),
                                                                ),
                                                                Text('Camera',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ))
                                                              ],
                                                            )),
                                                        InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                Navigator.pop(
                                                                    context);
                                                              });
                                                            },
                                                            splashColor:
                                                                HexColor(
                                                                    '#FA8072'),
                                                            child: Row(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child: Icon(
                                                                      Icons
                                                                          .remove_circle,
                                                                      color: HexColor(
                                                                          '#6bbcba')),
                                                                ),
                                                                Text('Remove',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ))
                                                              ],
                                                            ))
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        }),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    SizedBox(
                      height: 65.h,
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          fillColor: HexColor('#155564'),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: HexColor("#2dda9f"),
                                width: 2.0),
                          ),
                          border: OutlineInputBorder(),
                          hintText: "اسم المنتج",
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      height: 65.h,
                      child: TextField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          fillColor: HexColor('#155564'),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: HexColor("#2dda9f"),
                                width: 2.0),
                          ),
                          border: OutlineInputBorder(),
                          hintText: "تفاصيل المنتج",
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      height: 65.h,
                      child: TextField(
                        controller: priceController,
                        decoration: InputDecoration(
                          fillColor: HexColor('#155564'),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: HexColor("#2dda9f"),
                                width: 2.0),
                          ),
                          border: OutlineInputBorder(),
                          hintText: "السعر",
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      height: 65.h,
                      child: TextField(
                        controller: amountController,
                        decoration: InputDecoration(
                          fillColor: HexColor('#155564'),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: HexColor("#2dda9f"),
                                width: 2.0),
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'الكمية المتاحة',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                          width: double.infinity, height: 65.h),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: HexColor("#2dda9f"),
                        ),
                        onPressed: () async {
                          String name = nameController.text.trim();
                          String description =
                              descriptionController.text.trim();
                          int price = int.parse(priceController.text);
                          int amount = int.parse(amountController.text);

                          if (name.isEmpty ||
                              price == null ||
                              amount == null ||
                              imageUrl.isEmpty ||
                              description.isEmpty) {
                            CherryToast.info(
                              title: Text('Please Fill all Fields'),
                              actionHandler: () {},
                            ).show(context);
                            return;
                          }

                          User? user = FirebaseAuth.instance.currentUser;

                          if (user != null) {
                            String uid = user.uid;
                            int date = DateTime.now().millisecondsSinceEpoch;

                            DatabaseReference companyRef = FirebaseDatabase
                                .instance
                                .reference()
                                .child('feeds')
                                .child('${widget.companyName}');

                            String? id = companyRef.push().key;

                            await companyRef.child(id!).set({
                              'imageUrl': imageUrl,
                              'id': id,
                              'name': name,
                              'price': price,
                              'companyName': widget.companyName,
                              'amount': amount,
                              'description': description,
                            });
                          }
                          showAlertDialog(context);
                        },
                        child: Text('حفظ',style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

void showAlertDialog(BuildContext context) {
  Widget remindButton = TextButton(
    style: TextButton.styleFrom(
      primary: HexColor('#6bbcba'),
    ),
    child: Text("Ok"),
    onPressed: () {
      Navigator.pushNamed(context, CompanyHome.routeName);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Notice"),
    content: Text("تم أضافة المنتج"),
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
