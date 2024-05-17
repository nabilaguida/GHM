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
import 'package:greenhousemaintenance/utils/Cards.dart';
import 'package:greenhousemaintenance/utils/styles.dart';
import 'package:greenhousemaintenance/utils/thems.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../generated/l10n.dart';

class OrderCreationScreen extends StatefulWidget {
  final Category category;
  const OrderCreationScreen({super.key, required this.category});

  @override
  State<OrderCreationScreen> createState() => _OrderCreationScreenState();
}

class _OrderCreationScreenState extends State<OrderCreationScreen> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool urgent = false;
  String selectedsubcategory = '';
  final imagePicker = ImagePicker();

  List<File> selectedImages = [];
  Future<void> pickImages() async {
    final List<XFile>? pickedFiles =
    await imagePicker.pickMultiImage(maxHeight: 480, maxWidth: 640); // Optional: Set image dimensions
    if (pickedFiles != null) {
      // Limit selection to 3 images
      int addedImages = 0;
      for (var image in pickedFiles) {
        if (addedImages < 3) {
          setState(() {
            selectedImages.add(File(image.path));
            addedImages++;
          });
        } else {
          print('Maximum 3 images allowed. Selection limited.');
          break; // Exit the loop after adding 3 images
        }
      }
    } else {
      print('Image selection cancelled.');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    selectedsubcategory = arabicLocal() ? widget.category.subcategoriesAr.first : widget.category.subcategories.first;
    super.initState();
  }
  bool arabicLocal() {
    return Intl.getCurrentLocale() == 'ar';
  }

  void _showImagePreview(BuildContext context, File image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title:  Text('${S.of(context).Image_Preview}'),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    selectedImages.remove(image);
                  });
                  Navigator.pop(context); // Close the dialog
                },
              ),
            ],
          ),
          body: Center(
            child: Image.file(
              image,
              fit: BoxFit.contain, // Adjust fit as needed
            ),
          ),
        );
      },
    );
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${arabicLocal() ? widget.category.titleAr : widget.category.title}',
            style:MYText().mytextStyle(fontWeight: FontWeight.w600)
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {},
                icon: Image.network("${widget.category.image}"))
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: ListView(
            children: [
              Container(
                  margin: EdgeInsets.symmetric(vertical: height * 0.01),
                  width: width * 0.8,
                  child: Text(
                    '${S.of(context).fill_the_order_form}',
                    style: MYText().mytextStyle(
                        fontSize: 14, fontWeight: FontWeight.w400
                    ),
                    textAlign: TextAlign.start,
                  )),
              //*************************title ********************************
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
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: TextField(
                      controller: titlecontroller,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle:
                              MYText().mytextStyle(fontSize: 14, color: Colors.black26),
                          hintText: "${S.of(context).order_title}"),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: height * 0.01),
                  width: width * 0.8,
                  child: Text(
                    '${S.of(context).chose_subcategory}',
                    style: MYText().mytextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.start,
                  )),
              //*************************dropdown ********************************
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
                    ]),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: DropdownButton<String>(
                      value: selectedsubcategory, // Current selected title
                      isExpanded:
                          true, // Expand the dropdown to fill container width
                      underline: const SizedBox(), // Remove the underline
                      icon: const Icon(Icons.arrow_drop_down), // Dropdown icon
                      iconSize: 24,
                      onChanged: (value) {
                        setState(() {
                          selectedsubcategory =
                              value!; // Update selected title on change
                        });
                      },
                      items: (arabicLocal() ? widget.category.subcategoriesAr : widget.category.subcategories)
                          .map<DropdownMenuItem<String>>(
                              (title) => DropdownMenuItem<String>(
                            value: title,
                            child: SingleChildScrollView(child: Text(title,style: MYText().mytextStyle(),maxLines: 2,)),
                           ))
                          .toList()
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              //*************************description ********************************
              Container(
                width: width * 0.85,
                height: height * 0.12,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
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
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: TextField(
                      controller: descriptioncontroller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle:
                            MYText().mytextStyle(fontSize: 15, color: Colors.black26),
                        hintText: "${S.of(context).order_description}",
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                    ),
                  ),
                ),
              ),
              // ********************* phone ******************************************
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
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: TextField(
                      controller: phonecontroller,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle:
                              MYText().mytextStyle(fontSize: 14, color: Colors.black26),
                          hintText: "${S.of(context).phone_number_optional}"),
                    ),
                  ),
                ),
              ),
              // ********************* phone ******************************************
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
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: TextField(
                      controller: addresscontroller,
                      decoration: InputDecoration(
                          hintStyle:
                              MYText().mytextStyle(fontSize: 14, color: Colors.black26),
                          border: InputBorder.none,
                          hintText: "${S.of(context).address}"),
                    ),
                  ),
                ),
              ),
              //************************* order type ***************************
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: height * 0.01),
                  width: width * 0.8,
                  child: Text(
                    '${S.of(context).chose_order_type}',
                    style: MYText().mytextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.start,
                  )),
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                width: width * 0.8,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          urgent = true;
                        });
                      },
                      child: Container(
                        width: width * 0.4,
                        height: height * 0.06,
                        decoration: BoxDecoration(
                          color: urgent ? Palette.primary : Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xff2a824d).withOpacity(0.1),
                                spreadRadius: 6,
                                offset: Offset(0, 7.5),
                                blurRadius: 11.25)
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '${S.of(context).urgent}',
                            style: MYText().mytextStyle(fontWeight: FontWeight.bold,
                                color: urgent ? Colors.white : Palette.primary)
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          urgent = false;
                        });
                      },
                      child: Container(
                        width: width * 0.4,
                        height: height * 0.06,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: !urgent ? Palette.primary : Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xff2a824d).withOpacity(0.1),
                                spreadRadius: 6,
                                offset: Offset(0, 7.5),
                                blurRadius: 11.25)
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '${S.of(context).regular}',
                            style: MYText().mytextStyle(  fontWeight: FontWeight.bold,
                                color:
                                !urgent ? Colors.white : Palette.primary)
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              //******************************** images **************************
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: height * 0.01),
                  width: width * 0.8,
                  child: Text(
                    '${S.of(context).upload_images}',
                    style: MYText().mytextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.start,
                  )),
              SizedBox(
                height: height * 0.02,
              ),
              GridView.builder(
                shrinkWrap: true, // Adjust grid height as needed
                physics:
                    const NeverScrollableScrollPhysics(), // Disable scrolling
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Adjust number of images per row
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: selectedImages.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Center(
                      child: GestureDetector(
                        onTap: () async {
                          if(selectedImages.length<3){
                            await pickImages();
                          }else{
                          Cards().showSnackBar(context, '${S.of(context).You_already_picked_images}',isError: true);
                          }
                        },
                        child: Container(
                          height: height * 0.15,
                          width: height * 0.15,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xff2a824d).withOpacity(0.1),
                                  spreadRadius: 6,
                                  offset: Offset(0, 7.5),
                                  blurRadius: 11.25)
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              size: 64,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return GestureDetector(
                      onTap: () => _showImagePreview(
                          context,
                          selectedImages[index - 1]), // Call function on tap
                      child: Center(
                        child: Container(
                          height: height * 0.15,
                          width: height * 0.15,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            image: DecorationImage(
                                image: FileImage(
                                    File(selectedImages[index - 1].path))),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xff2a824d).withOpacity(0.1),
                                  spreadRadius: 6,
                                  offset: Offset(0, 7.5),
                                  blurRadius: 11.25)
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Visibility(
                visible: !isLoading,
                child: Center(
                  child: GestureDetector(
                    onTap: () async {
                      if (titlecontroller.text.isNotEmpty) {
                        setState(() {
                          isLoading = true;
                        });
                        await context.read<OrderProvider>().insertOrder(
                            context,
                            MyOrder(
                                userId: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc('${firebaseAuth.currentUser!.uid}'),
                                date: DateTime.now(),
                                title: titlecontroller.text,
                                status: 0,
                                adress: addresscontroller.text.isNotEmpty
                                    ? addresscontroller.text.trim()
                                    : "No adress",
                                description: descriptioncontroller.text,
                                phonenb: phonecontroller.text.isEmpty
                                    ? '${firebaseAuth.currentUser!.phoneNumber}'
                                    : phonecontroller.text.trim(),
                                subcategory: selectedsubcategory,
                                category: widget.category.categoryId!,
                                urgent: urgent),
                            selectedImages);
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    child: Container(
                      height: height * 0.07,
                      width: width * 0.85,
                      child: Center(
                        child: Text(
                          "${S.of(context).submit_order}",
                          style:MYText().mytextStyle(fontSize: 14, color: Colors.white)
                        ),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: isLoading
                              ? BorderRadius.all(Radius.circular(200))
                              : BorderRadius.all(Radius.circular(30)),
                          color: Palette.primary),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: isLoading,
                child: Center(
                    child: CircularProgressIndicator(
                  color: Palette.primary,
                )),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Center(
                  child: Text(
                '------ ${S.of(context).or} ------',
                style: MYText().mytextStyle(fontWeight: FontWeight.w600)
              )),
              SizedBox(
                height: height * 0.02,
              ),
              GestureDetector(
                onTap: () {
                  context.read<OrderProvider>().openWhatsAppChat(
                      '${S.of(context).whatsapp_category_01} ${FirebaseAuth.instance.currentUser!.displayName!.toUpperCase()} ${S.of(context).whatsapp_category_02} ${arabicLocal() ? widget.category.titleAr:widget.category.title.toUpperCase()}.',
                      "+97470900279");
                },
                child: Center(
                  child: Container(
                    width: width * 0.85,
                    height: height * 0.07,
                    decoration: BoxDecoration(
                        color: Colors
                            .white, // Adjust color as needed for button look
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xff2a824d)
                                  .withOpacity(0.1), // Adjust for button look
                              spreadRadius: 6,
                              offset: Offset(0, 7.5),
                              blurRadius: 11.25)
                        ]),
                    child: Center(
                        child: Row(
                      children: [
                        Spacer(),
                        Image.asset(
                          "assets/whatsapp.png",
                          width: width * 0.08,
                        ),
                        Spacer(),
                        Text(
                          '${S.of(context).contact_us_on_whatsapp}',
                          style: MYText().mytextStyle(fontWeight: FontWeight.bold, color: Colors.green)
                        ),
                        Spacer(),
                      ],
                    )),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
