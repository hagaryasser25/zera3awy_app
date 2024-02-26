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
import 'package:zera3awy_app/farm/farm_home.dart';

class AddProduct extends StatefulWidget {
  String farmName;

  AddProduct({required this.farmName});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String imageUrl = '';
  File? image;
  var nameController = TextEditingController();
  var priceController = TextEditingController();
  var amountController = TextEditingController();
  var descriptionController = TextEditingController();
  String dropdownValue = "كيلو";

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
            body: SingleChildScrollView(
              child: Padding(
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
                                      backgroundColor:
                                          Color.fromARGB(255, 241, 240, 240),
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
                                                            color: HexColor(
                                                                "#2dda9f"))),
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
                                  color: HexColor("#2dda9f"), width: 2.0),
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
                                  color: HexColor("#2dda9f"), width: 2.0),
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
                                  color: HexColor("#2dda9f"), width: 2.0),
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
                                  color: HexColor("#2dda9f"), width: 2.0),
                            ),
                            border: OutlineInputBorder(),
                            hintText: 'الكمية المتاحة',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DecoratedBox(
                        decoration: ShapeDecoration(
                          shape: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 183, 183, 183),
                                width: 2.0),
                          ),
                        ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          underline: SizedBox(),
                                    
                          // Step 3.
                          value: dropdownValue,
                          icon: Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Icon(Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 119, 118, 118)),
                          ),
                                    
                          // Step 4.
                          items: ["كيلو","قطعة"]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: 5,
                                ),
                                child: Text(
                                  value,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color:
                                          Color.fromARGB(255, 119, 118, 118)),
                                ),
                              ),
                            );
                          }).toList(),
                          // Step 5.
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
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
                                  .child('products')
                                  .child('${widget.farmName}');
              
                              String? id = companyRef.push().key;
              
                              await companyRef.child(id!).set({
                                'imageUrl': imageUrl,
                                'id': id,
                                'name': name,
                                'price': price,
                                'companyName': widget.farmName,
                                'amount': amount,
                                'description': description,
                                "type": dropdownValue,
                              });
                            }
                            showAlertDialog(context);
                          },
                          child: Text(
                            'حفظ',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
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
      Navigator.pushNamed(context, FarmHome.routeName);
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
