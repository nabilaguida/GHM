import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenhousemaintenance/models/category.dart';
import 'package:greenhousemaintenance/providers/categoriesProvider.dart';
import 'package:greenhousemaintenance/utils/thems.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'categoriesCreation.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
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
    getCategories();
    super.initState();
  }

  Future<void> getCategories() async {
    mycategories = await context.read<CategoriesProvider>().getCategories();
    setState(() {
      fetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Consumer<CategoriesProvider>(
        builder: (context, cateProvider, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Manage Categories'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.category_outlined,
                  color: Colors.green,
                ))
          ],
        ),
        body: fetched
            ? Column(
                children: [
                  Expanded(
                    child: Container(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await getCategories();
                        },
                        child: ListView(
                          children: [
                            //******************************************* title ******************************
                            Center(
                              child: Container(
                                width: width * 0.9,
                                child: Row(
                                  children: [
                                    Text(
                                      'Available Services',
                                      style: GoogleFonts.ibmPlexSans(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            ListView(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              children: mycategories
                                  .map((category) {
                                return Center(
                                    child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: height * 0.01),
                                  width: width * 0.95,
                                  height: height * 0.2,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0xff2a824d)
                                                .withOpacity(0.1),
                                            spreadRadius: 6,
                                            offset: Offset(0, 7.5),
                                            blurRadius: 11.25)
                                      ],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Row(
                                    children: [
                                      Container(
                                          width: width * 0.32,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width * 0.03),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: Image.network(
                                                  "${category.image}",
                                                  width: width * 0.1,
                                                ),
                                              ),
                                              SizedBox(
                                                height: height * 0.01,
                                              ),
                                              Center(
                                                child: Text(
                                                  "${category.title}",
                                                  // 'Aguida Mohamed Nabil',
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      GoogleFonts.ibmPlexSans(
                                                          height: 1.2,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14),
                                                ),
                                              )
                                            ],
                                          )),
                                      Container(
                                        height: height * 0.1,
                                        child: RotatedBox(
                                          quarterTurns: 1,
                                          child: Divider(
                                            color: Colors.green,
                                            thickness: 1,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: height * 0.02),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Wrap(
                                              children: category.subcategories
                                                  .map((subcat) => Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 2,
                                                              vertical: 2),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8)),
                                                          border: Border.all(
                                                              width: 1,
                                                              color: Colors.grey
                                                                  .shade400)),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 2,
                                                              vertical: 2),
                                                      child: Text(
                                                        "${subcat}",
                                                        style: GoogleFonts
                                                            .ibmPlexSans(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .grey
                                                                    .shade600),
                                                      )))
                                                  .toList()),
                                        ),
                                      )),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: width * 0.04,
                                              height: width * 0.04,
                                              decoration: BoxDecoration(
                                                color: category.visible ? Palette.primary : Colors.red,
                                                shape: BoxShape.circle
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                titlecontroller.clear();
                                                //*********************************************************************************
                                                context.read<CategoriesProvider>().setVisible(category.visible);
                                                await context
                                                    .read<CategoriesProvider>()
                                                    .setSubCategoriesForEdit(
                                                        category.subcategories);
                                                showModalBottomSheet(
                                                    context: context,
                                                    builder: (context) {
                                                      return Consumer<
                                                              CategoriesProvider>(
                                                          builder: (context,
                                                              showmodalProvider,
                                                              child) {
                                                        return Container(
                                                          height: height * 0.45,
                                                          width: width,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          20),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20))),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: height *
                                                                    0.02,
                                                              ),
                                                              Text(
                                                                'Edit category',
                                                                style: GoogleFonts.ibmPlexSans(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              SizedBox(
                                                                height: height *
                                                                    0.02,
                                                              ),
                                                              Container(
                                                                width: width *
                                                                    0.85,
                                                                height: height *
                                                                    0.07,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              30)),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        color: Color(0xff2a824d).withOpacity(
                                                                            0.1),
                                                                        spreadRadius:
                                                                            6,
                                                                        offset: Offset(
                                                                            0,
                                                                            7.5),
                                                                        blurRadius:
                                                                            11.25)
                                                                  ],
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              EdgeInsets.symmetric(horizontal: width * 0.05),
                                                                          child:
                                                                              TextField(
                                                                            controller:
                                                                                subcatecontroller,
                                                                            decoration: InputDecoration(
                                                                                border: InputBorder.none,
                                                                                hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
                                                                                hintText: "Add sub-category"),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: width *
                                                                          0.12,
                                                                      decoration: BoxDecoration(
                                                                          color: Palette
                                                                              .primary,
                                                                          borderRadius: BorderRadius.only(
                                                                              topRight: Radius.circular(30),
                                                                              bottomRight: Radius.circular(30))),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            //******************************************
                                                                            if (subcatecontroller.text.isNotEmpty) {
                                                                              showmodalProvider.addSubCategory(subcatecontroller.text);
                                                                              subcatecontroller.clear();
                                                                            }
                                                                          },
                                                                          icon:
                                                                              Icon(
                                                                            Icons.add,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                width:
                                                                    width * 0.9,
                                                                height: height *
                                                                    0.1,
                                                                child: ListView(
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  children: showmodalProvider
                                                                      .subcategories
                                                                      .map((subcategory) =>
                                                                          Center(
                                                                            child: Container(
                                                                                margin: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: height * 0.01),
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                                  color: Colors.white,
                                                                                  boxShadow: [
                                                                                    BoxShadow(color: Color(0xff2a824d).withOpacity(0.1), spreadRadius: 6, offset: Offset(0, 7.5), blurRadius: 11.25)
                                                                                  ],
                                                                                ),
                                                                                padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: 2),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Text(
                                                                                      "${subcategory}",
                                                                                      style: GoogleFonts.ibmPlexSans(fontSize: 14, color: Colors.grey.shade900),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: width * 0.04,
                                                                                    ),
                                                                                    InkWell(
                                                                                        onTap: () => showmodalProvider.removeSubCategory(subcategory),
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
                                                              Spacer(),
                                                              Visibility(
                                                                visible:
                                                                    showmodalProvider
                                                                            .isLoading ==
                                                                        false,
                                                                child: Row(
                                                                  children: [
                                                                    Spacer(),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        await showmodalProvider
                                                                            .setLoading();
                                                                        await showmodalProvider.UpdateCategory(
                                                                            context,
                                                                            category
                                                                                .categoryId);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            height *
                                                                                0.07,
                                                                        width:
                                                                            width *
                                                                                0.6,
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            "Save Changes",
                                                                            style: GoogleFonts.ibmPlexSans(
                                                                                fontSize:
                                                                                    14,
                                                                                color:
                                                                                    Colors.white),
                                                                          ),
                                                                        ),
                                                                        decoration: BoxDecoration(
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                  color: Color(0xff2a824d).withOpacity(0.1),
                                                                                  spreadRadius: 6,
                                                                                  offset: Offset(0, 7.5),
                                                                                  blurRadius: 11.25)
                                                                            ],
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(
                                                                                    20)),
                                                                            color: Palette
                                                                                .primary),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: width * 0.05,
                                                                    ),
                                                                    Text(
                                                                      'Visible',
                                                                      style: GoogleFonts
                                                                          .ibmPlexSans(),
                                                                    ),
                                                                    SizedBox(
                                                                      width: width * 0.02,
                                                                    ),
                                                                    Switch(
                                                                        activeColor:
                                                                        Palette.primary,
                                                                        inactiveTrackColor:
                                                                        Colors.grey.shade100,
                                                                        value: showmodalProvider
                                                                            .visible,
                                                                        onChanged: (value) {
                                                                          showmodalProvider
                                                                              .setVisible(value);
                                                                        }),
                                                                    Spacer()
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: height *
                                                                    0.01,
                                                              ),
                                                              Visibility(
                                                                visible:
                                                                    showmodalProvider
                                                                            .isLoading ==
                                                                        false,
                                                                child: InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    await showmodalProvider
                                                                        .setLoading();
                                                                    await showmodalProvider.deleteCategory(
                                                                        context,
                                                                        category
                                                                            .categoryId);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        height *
                                                                            0.07,
                                                                    width:
                                                                        width *
                                                                            0.85,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "Delete Category",
                                                                        style: GoogleFonts.ibmPlexSans(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                              color: Color(0xff2a824d).withOpacity(0.1),
                                                                              spreadRadius: 6,
                                                                              offset: Offset(0, 7.5),
                                                                              blurRadius: 11.25)
                                                                        ],
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(
                                                                                20)),
                                                                        color: Colors
                                                                            .red),
                                                                  ),
                                                                ),
                                                              ),
                                                              Visibility(
                                                                visible:
                                                                    showmodalProvider
                                                                            .isLoading ==
                                                                        true,
                                                                child: Center(
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                  color: Palette
                                                                      .primary,
                                                                )),
                                                              ),
                                                              SizedBox(
                                                                height: height *
                                                                    0.02,
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                    });
                                              },
                                              icon: Icon(
                                                Icons.edit,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ));
                              }).toList(),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: height * 0.12,
                    child: Center(
                      child: Container(
                        width: width,
                        child: Center(
                          child: GestureDetector(
                            onTap: () async {
                              titlecontroller.clear();
                              //******************************************************** create category *********************************************
                              context.read<CategoriesProvider>().resetVars();
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryCreationScreen()));
                              //*********************************************************************************************************************
                            },
                            child: Container(
                              height: height * 0.07,
                              width: width * 0.85,
                              child: Center(
                                child: Text(
                                  "Add Category",
                                  style: GoogleFonts.ibmPlexSans(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color(0xff2a824d).withOpacity(0.1),
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
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: Container(
                  width: width * 0.3,
                  child: LinearProgressIndicator(
                    color: Palette.primary,
                  ),
                ),
              ),
      );
    });
  }
}
