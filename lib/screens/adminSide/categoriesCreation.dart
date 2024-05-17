import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenhousemaintenance/models/category.dart';
import 'package:greenhousemaintenance/models/order.dart';
import 'package:greenhousemaintenance/providers/orderProvider.dart';
import 'package:greenhousemaintenance/screens/home_screen.dart';
import 'package:greenhousemaintenance/utils/thems.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/categoriesProvider.dart';

class CategoryCreationScreen extends StatefulWidget {
  const CategoryCreationScreen({super.key});

  @override
  State<CategoryCreationScreen> createState() => _CategoryCreationScreenState();
}

class _CategoryCreationScreenState extends State<CategoryCreationScreen> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController titlecontrollerAr = TextEditingController();
  TextEditingController weightcontroller = TextEditingController();
  TextEditingController subcatecontroller = TextEditingController();
  TextEditingController subcatecontrollerAr = TextEditingController();
  final imagePicker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      context.read<CategoriesProvider>().setImage(pickedFile.path);
    } else {
      print('Image selection cancelled.');
    }
  }

  List<Category> mycategories = [];
  bool fetched = false;
  int weight = 0;

  @override
  void initState() {
    // TODO: implement initState
    // selectedsubcategory = widget.category.subcategories.first;
    super.initState();
  }

  // void _showImagePreview(BuildContext context, String imagePath) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Scaffold(
  //         appBar: AppBar(
  //           title: const Text('Image Preview'),
  //           actions: [
  //             IconButton(
  //               icon: const Icon(
  //                 Icons.delete,
  //                 color: Colors.red,
  //               ),
  //               onPressed: () {
  //                 setState(() {
  //                   selectedImages.remove(imagePath);
  //                 });
  //                 Navigator.pop(context); // Close the dialog
  //               },
  //             ),
  //           ],
  //         ),
  //         body: Center(
  //           child: Image.file(
  //             File(imagePath),
  //             fit: BoxFit.contain, // Adjust fit as needed
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Consumer<CategoriesProvider>(
        builder: (context, showmodalProvider, child) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Add New Category',
              style: GoogleFonts.ibmPlexSans(fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: Container(
              height: height,
              width: width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        margin: EdgeInsets.symmetric(vertical: height * 0.01),
                        width: width * 0.8,
                        child: Text(
                          'Please fill the form (English Version).',
                          style: GoogleFonts.ibmPlexSans(
                              fontSize: 14, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.start,
                        )),
                    Container(
                      width: width * 0.85,
                      height: height * 0.07,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xff2a824d).withOpacity(0.1),
                              spreadRadius: 6,
                              offset: Offset(0, 7.5),
                              blurRadius: 11.25)
                        ],
                      ),
                      child: Center(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.05),
                          child: TextField(
                            controller: titlecontroller,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    color: Colors.black26, fontSize: 14),
                                hintText: "Category title"),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      width: width * 0.85,
                      height: height * 0.07,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xff2a824d).withOpacity(0.1),
                              spreadRadius: 6,
                              offset: Offset(0, 7.5),
                              blurRadius: 11.25)
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.05),
                                child: TextField(
                                  controller: subcatecontroller,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                          color: Colors.black26, fontSize: 14),
                                      hintText: "Add sub-category"),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: width * 0.12,
                            decoration: BoxDecoration(
                                color: Palette.primary,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    bottomRight: Radius.circular(30))),
                            child: Center(
                              child: IconButton(
                                onPressed: () {
                                  //******************************************
                                  if (subcatecontroller.text.isNotEmpty) {
                                    showmodalProvider
                                        .addSubCategory(subcatecontroller.text);
                                    subcatecontroller.clear();
                                  }
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: width * 0.9,
                      height: height * 0.1,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: showmodalProvider.subcategories
                            .map((subcategory) => Center(
                                  child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: width * 0.02,
                                          vertical: height * 0.01),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color(0xff2a824d)
                                                  .withOpacity(0.1),
                                              spreadRadius: 6,
                                              offset: Offset(0, 7.5),
                                              blurRadius: 11.25)
                                        ],
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.04,
                                          vertical: 2),
                                      child: Row(
                                        children: [
                                          Text(
                                            "${subcategory}",
                                            style: GoogleFonts.ibmPlexSans(
                                                fontSize: 18,
                                                color: Colors.grey.shade900),
                                          ),
                                          SizedBox(
                                            width: width * 0.04,
                                          ),
                                          InkWell(
                                              onTap: () => showmodalProvider
                                                  .removeSubCategory(
                                                      subcategory),
                                              child: Icon(
                                                Icons.cancel,
                                                color: Colors.red.shade600,
                                                size: 20,
                                              ))
                                        ],
                                      )),
                                ))
                            .toList(),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(vertical: height * 0.01),
                        width: width * 0.8,
                        child: Text(
                          'Please fill the form (Arabic Version).',
                          style: GoogleFonts.ibmPlexSans(
                              fontSize: 14, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.start,
                        )),
                    Container(
                      width: width * 0.85,
                      height: height * 0.07,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xff2a824d).withOpacity(0.1),
                              spreadRadius: 6,
                              offset: Offset(0, 7.5),
                              blurRadius: 11.25)
                        ],
                      ),
                      child: Center(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.05),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextField(
                              controller: titlecontrollerAr,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      color: Colors.black26, fontSize: 14),
                                  hintText: "عنوان الفئة"),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      width: width * 0.85,
                      height: height * 0.07,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xff2a824d).withOpacity(0.1),
                              spreadRadius: 6,
                              offset: Offset(0, 7.5),
                              blurRadius: 11.25)
                        ],
                      ),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Expanded(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.05),
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextField(
                                    controller: subcatecontrollerAr,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                            color: Colors.black26,
                                            fontSize: 14),
                                        hintText: "اضف فئة فرعية"),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: width * 0.12,
                            decoration: BoxDecoration(
                                color: Palette.primary,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    bottomLeft: Radius.circular(30))),
                            child: Center(
                              child: IconButton(
                                onPressed: () {
                                  //******************************************
                                  if (subcatecontrollerAr.text.isNotEmpty) {
                                    showmodalProvider.addSubCategoryAr(
                                        subcatecontrollerAr.text);
                                    subcatecontrollerAr.clear();
                                  }
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: width * 0.9,
                      height: height * 0.1,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: showmodalProvider.subcategoriesAr
                              .map((subcategory) => Center(
                                    child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: width * 0.02,
                                            vertical: height * 0.01),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color(0xff2a824d)
                                                    .withOpacity(0.1),
                                                spreadRadius: 6,
                                                offset: Offset(0, 7.5),
                                                blurRadius: 11.25)
                                          ],
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.04,
                                            vertical: 2),
                                        child: Row(
                                          children: [
                                            Text(
                                              "${subcategory}",
                                              style: GoogleFonts.ibmPlexSans(
                                                  fontSize: 18,
                                                  color: Colors.grey.shade900),
                                            ),
                                            SizedBox(
                                              width: width * 0.04,
                                            ),
                                            InkWell(
                                                onTap: () => showmodalProvider
                                                    .removeSubCategoryAr(
                                                        subcategory),
                                                child: Icon(
                                                  Icons.cancel,
                                                  color: Colors.red.shade600,
                                                  size: 20,
                                                ))
                                          ],
                                        )),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      width: width * 0.85,
                      child: Row(
                        children: [
                          Container(
                              width: width * 0.5,
                              child: Center(
                                child: Text(
                                  'Upload the image of the category',
                                  textAlign: TextAlign.start,
                                ),
                              )),
                          Spacer(),
                          Center(
                            child: GestureDetector(
                              onTap: () async {
                                await pickImage();
                              },
                              child: Container(
                                height: height * 0.12,
                                width: height * 0.12,
                                decoration:
                                showmodalProvider.selectedImagePath != ''
                                    ? BoxDecoration(
                                  color: Colors.white,
                                  image: DecorationImage(
                                      image: FileImage(File(
                                          showmodalProvider
                                              .selectedImagePath)),
                                      fit: BoxFit.contain),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(15)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0xff2a824d)
                                            .withOpacity(0.1),
                                        spreadRadius: 6,
                                        offset: Offset(0, 7.5),
                                        blurRadius: 11.25)
                                  ],
                                )
                                    : BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(15)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0xff2a824d)
                                            .withOpacity(0.1),
                                        spreadRadius: 6,
                                        offset: Offset(0, 7.5),
                                        blurRadius: 11.25)
                                  ],
                                ),
                                child: showmodalProvider.selectedImagePath != ''
                                    ? Container()
                                    : Center(
                                  child: Icon(
                                    Icons.add,
                                    size: 64,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    //********************************* images ********************************
                    Container(
                      width: width * 0.85,
                      child: Row(
                        children: [
                          Container(
                              width: width * 0.5,
                              child: Center(
                                child: Text(
                                  'Set the category weight. (number). ',
                                  textAlign: TextAlign.start,
                                ),
                              )),
                          Spacer(),
                          Center(
                            child:  Container(
                              width: width * 0.3,
                              height: height * 0.07,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.all(
                                    Radius.circular(
                                        30)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(
                                          0xff2a824d)
                                          .withOpacity(0.1),
                                      spreadRadius: 6,
                                      offset:
                                      Offset(0, 7.5),
                                      blurRadius: 11.25)
                                ],
                              ),
                              child: Center(
                                child: Padding(
                                  padding:
                                  EdgeInsets.symmetric(
                                      horizontal:
                                      width * 0.05),
                                  child: TextField(
                                    controller:
                                    weightcontroller,
                                    keyboardType:
                                    TextInputType
                                        .number,
                                    decoration: InputDecoration(
                                        border: InputBorder
                                            .none,
                                        hintStyle: TextStyle(
                                            color: Colors
                                                .black26,
                                            fontSize: 14),
                                        hintText: "Weight"),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Visibility(
                      visible: showmodalProvider.isLoading == false,
                      child: Row(
                        children: [
                          Spacer(),
                          Visibility(
                            visible: showmodalProvider.isLoading == false,
                            child: InkWell(
                              onTap: () async {
                                await showmodalProvider.setLoading();
                                if (titlecontroller.text.isNotEmpty &&
                                    showmodalProvider
                                        .subcategories.isNotEmpty) {
                                  await showmodalProvider.InsertCategory(
                                      context,
                                      Category(
                                          titleAr: titlecontrollerAr.text,
                                          weight:  weightcontroller.text.isEmpty ? 0 : int.parse(weightcontroller
                                              .text
                                              .trim()
                                              .toString()),
                                          visible: showmodalProvider.visible,
                                          title: titlecontroller.text,
                                          subcategories:
                                              showmodalProvider.subcategories,
                                          subcategoriesAr: showmodalProvider
                                              .subcategoriesAr),
                                      showmodalProvider.selectedImagePath);
                                  Navigator.pop(context);
                                }
                              },
                              child: Container(
                                height: height * 0.07,
                                width: width * 0.5,
                                child: Center(
                                  child: Text(
                                    "Save Category",
                                    style: GoogleFonts.ibmPlexSans(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(0xff2a824d)
                                              .withOpacity(0.1),
                                          spreadRadius: 6,
                                          offset: Offset(0, 7.5),
                                          blurRadius: 11.25)
                                    ],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: Palette.primary),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.05,
                          ),
                          Text(
                            'Visible',
                            style: GoogleFonts.ibmPlexSans(),
                          ),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          Switch(
                              activeColor: Palette.primary,
                              inactiveTrackColor: Colors.grey.shade100,
                              value: showmodalProvider.visible,
                              onChanged: (value) {
                                showmodalProvider.setVisible(value);
                              }),
                          Spacer()
                        ],
                      ),
                    ),
                    Visibility(
                      visible: showmodalProvider.isLoading == true,
                      child: Center(
                          child: CircularProgressIndicator(
                        color: Palette.primary,
                      )),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
