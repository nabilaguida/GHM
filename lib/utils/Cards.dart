import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenhousemaintenance/models/User.dart';
import 'package:greenhousemaintenance/models/category.dart';
import 'package:greenhousemaintenance/models/order.dart';
import 'package:greenhousemaintenance/providers/orderProvider.dart';
import 'package:greenhousemaintenance/screens/home_screen.dart';
import 'package:greenhousemaintenance/utils/styles.dart';
import 'package:greenhousemaintenance/utils/thems.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';
import '../providers/categoriesProvider.dart';

class Cards {
  static Widget orderCard(BuildContext context, MyOrder order) {
    void _showImagePreview(BuildContext context, String imagePath) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('${S.of(context).Image_Preview}',style: MYText().mytextStyle(),),
            ),
            body: Center(
              child: Image.network(
                imagePath,
                fit: BoxFit.contain, // Adjust fit as needed
              ),
            ),
          );
        },
      );
    }

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Center(
        child: GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Consumer<CategoriesProvider>(
                  builder: (context, showmodalProvider, child) {
                return SizedBox(
                  height: height * 0.8,
                  width: width,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: ListView(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.05,
                              vertical: height * 0.02),
                          child: Text(
                            '${S.of(context).Check_Status}',
                            style: MYText().mytextStyle( fontSize: 16, fontWeight: FontWeight.w600)
                          ),
                        ),
                        ListTile(
                            title: Text(
                              order.title,
                              style: MYText().mytextStyle(fontWeight: FontWeight.bold)
                            ),
                            subtitle: Text(order.subcategory),
                            leading: Image.network(
                              "${context.read<CategoriesProvider>().categories.where((cat) => cat.categoryId == order.category).first.image}",
                              width: width * 0.1,
                            ),
                            trailing: Container(
                              width: width * 0.22,
                              height: height * 0.04,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(60)),
                                color: order.status == 0
                                    ? Colors.amber
                                    : order.status == 1
                                        ? Colors.lightBlueAccent
                                        : order.status == 2
                                            ? Palette.primary
                                            : Colors.red,
                              ),
                              child: Center(
                                child: Text(
                                  order.status == 0
                                      ? '${S.of(context).pending_status}'
                                      : order.status == 1
                                          ? '${S.of(context).ongoing_status}'
                                          : order.status == 2
                                              ? '${S.of(context).completed_status}'
                                              : '${S.of(context).canceled_status}',
                                  style: MYText().mytextStyle(  color: Colors.white,
                                      fontWeight: FontWeight.bold)
                                ),
                              ),
                            )),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.05),
                          child: Text(
                            '${S.of(context).order_description}:',
                            style: MYText().mytextStyle(fontWeight: FontWeight.bold)
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.05),
                          child: Text(
                            order.description,style: MYText().mytextStyle(),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.05),
                          child: Text(
                            '${S.of(context).Order_pics}:',
                            style: MYText().mytextStyle(fontWeight: FontWeight.bold)
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.05),
                          height: height * 0.2,
                          child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              physics: ScrollPhysics(),
                              children: order.images!.map((image) {
                                return GestureDetector(
                                  onTap: () => _showImagePreview(
                                      context, image), // Call function on tap
                                  child: Center(
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: width * 0.02),
                                      height: height * 0.15,
                                      width: height * 0.15,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        image: DecorationImage(
                                            image: NetworkImage(image),
                                            fit: BoxFit.cover),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color(0xff2a824d)
                                                  .withOpacity(0.1),
                                              spreadRadius: 6,
                                              offset: Offset(0, 7.5),
                                              blurRadius: 11.25)
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList()),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.05,
                                vertical: height * 0.02),
                            width: width * 0.85,
                            height: height * 0.07,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xff2a824d).withOpacity(0.1),
                                    spreadRadius: 6,
                                    offset: Offset(0, 7.5),
                                    blurRadius: 11.25)
                              ],
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                  Text(
                                    '${S.of(context).address}',
                                    style: MYText().mytextStyle(fontWeight: FontWeight.bold)
                                  ),
                                  Spacer(),
                                  Expanded(
                                    child: Text(
                                      '${order.adress}',
                                      style: MYText().mytextStyle(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.05,
                                vertical: height * 0.02),
                            width: width * 0.85,
                            height: height * 0.07,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xff2a824d).withOpacity(0.1),
                                    spreadRadius: 6,
                                    offset: Offset(0, 7.5),
                                    blurRadius: 11.25)
                              ],
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                  Text(
                                    '${S.of(context).Date_Posted}',
                                    style:MYText().mytextStyle(fontWeight: FontWeight.bold)
                                  ),
                                  Spacer(),
                                  Expanded(
                                    child: Text(
                                      '${order.date.day}/${order.date.month}/${order.date.year}',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        InkWell(
                          onTap: () {
                            context.read<OrderProvider>().openWhatsAppChat(
                                '${S.of(context).whatsapp_category_01} ${FirebaseAuth.instance.currentUser!.displayName!.toUpperCase()} ${S.of(context).whatsapp_category_02}\n orderID:${order.orderId}',
                                '+97470900279');
                          },
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.05),
                            child: Container(
                              height: height * 0.06,
                              decoration: BoxDecoration(
                                  color: Colors
                                      .white, // Adjust color as needed for button look
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0xff2a824d).withOpacity(
                                            0.1), // Adjust for button look
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
                                    style: MYText().mytextStyle( fontWeight: FontWeight.bold,
                                        color: Palette.primary)
                                  ),
                                  Spacer(),
                                ],
                              )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Visibility(
                          visible: order.status == 0,
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.05),
                            child: InkWell(
                              onTap: () async{
                                await context
                                    .read<OrderProvider>()
                                    .updateOrder(context, -1, order.orderId);
                                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                                },
                              child: Center(
                                child: Container(
                                  height: height * 0.06,
                                  child: Center(
                                    child: Text(
                                      "${S.of(context).Cancel_Order}",
                                      style: MYText().mytextStyle(fontSize: 14, color: Colors.white)
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
                                      color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        )
                      ],
                    ),
                  ),
                );
              });
            });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: height * 0.01),
        width: width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color(0xff2a824d).withOpacity(0.1),
                spreadRadius: 6,
                offset: Offset(0, 7.5),
                blurRadius: 11.25)
          ],
        ),
        child: Column(
          children: [
            ListTile(
                title: Text(
                  "${order.title}",
                  style: MYText().mytextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                    '${order.date.day}/${order.date.month}/${order.date.year} : ${order.date.hour}: ${order.date.minute}'),
                trailing: Container(
                  width: width * 0.22,
                  height: height * 0.04,
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(60)),
                    color: order.status == 0
                        ? Colors.amber
                        : order.status == 1
                            ? Colors.lightBlueAccent
                            : order.status == 2
                                ? Palette.primary
                                : Colors.red,
                  ),
                  child: Center(
                    child: Text(
                      order.status == 0
                          ? '${S.of(context).pending_status}'
                          : order.status == 1
                              ? '${S.of(context).ongoing_status}'
                              : order.status == 2
                                  ? '${S.of(context).completed_status}'
                                  : '${S.of(context).canceled_status}',
                      style: MYText().mytextStyle(color: Colors.white),
                    ),
                  ),
                )),
            ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${S.of(context).address}: ',
                            style:MYText().mytextStyle( fontWeight: FontWeight.bold,
                                color: Colors.black)
                          ),
                          TextSpan(
                            text: '${order.adress}',
                            style: MYText().mytextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                trailing: Image.network(
                  "${context.read<CategoriesProvider>().categories.where((cat) => cat.categoryId == order.category).first.image}",
                  width: width * 0.08,
                ))
          ],
        ),
      ),
    ));
  }

  //******************************** admin order card ************************************//
  static Widget adminorderCard(
      BuildContext context, MyOrder order, MyUser client, Category category) {
    void _showImagePreview(BuildContext context, String imagePath) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Image Preview'),
            ),
            body: Center(
              child: Image.network(
                imagePath,
                fit: BoxFit.contain, // Adjust fit as needed
              ),
            ),
          );
        },
      );
    }

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Center(
        child: GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Consumer<CategoriesProvider>(
                  builder: (context, showmodalProvider, child) {
                return SizedBox(
                  height: height * 0.8,
                  width: width,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: ListView(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.05,
                              vertical: height * 0.02),
                          child: Text(
                            'Check Status',
                            style: GoogleFonts.ibmPlexSans(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        ListTile(
                            title: Text(
                              order.title,
                              style: GoogleFonts.ibmPlexSans(
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(order.subcategory),
                            leading: Image.network(
                              '${category.image}',
                              width: width * 0.1,
                            ),
                            trailing: Container(
                              width: width * 0.25,
                              height: height * 0.04,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(60)),
                                color: order.status == 0
                                    ? Colors.amber
                                    : order.status == 1
                                        ? Colors.lightBlueAccent
                                        : order.status == 2
                                            ? Palette.primary
                                            : Colors.red,
                              ),
                              child: Center(
                                child: Text(
                                  order.status == 0
                                      ? 'Pending'
                                      : order.status == 1
                                          ? 'Ongoing'
                                          : order.status == 2
                                              ? 'Completed'
                                              : 'Canceled',
                                  style: GoogleFonts.ibmPlexSans(
                                      color: Colors.white),
                                ),
                              ),
                            )),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.05),
                          child: Text(
                            'Ordered By:',
                            style: GoogleFonts.ibmPlexSans(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.05),
                          child: Text(
                            client.fullName.toUpperCase(),
                            style: GoogleFonts.ibmPlexSans(
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                                fontSize: 14),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.05),
                          child: Text(
                            'Order Description:',
                            style: GoogleFonts.ibmPlexSans(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.05),
                          child: Text(
                            order.description,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.05),
                          child: Text(
                            'Order pics:',
                            style: GoogleFonts.ibmPlexSans(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.05),
                          height: height * 0.2,
                          child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              physics: ScrollPhysics(),
                              children: order.images!.map((image) {
                                return GestureDetector(
                                  onTap: () => _showImagePreview(
                                      context, image), // Call function on tap
                                  child: Center(
                                    child: Container(
                                      height: height * 0.15,
                                      width: height * 0.15,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: width * 0.02),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        image: DecorationImage(
                                            image: NetworkImage(image),
                                            fit: BoxFit.cover),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color(0xff2a824d)
                                                  .withOpacity(0.1),
                                              spreadRadius: 6,
                                              offset: Offset(0, 7.5),
                                              blurRadius: 11.25)
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList()),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.05,
                                vertical: height * 0.02),
                            width: width * 0.85,
                            height: height * 0.07,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xff2a824d).withOpacity(0.1),
                                    spreadRadius: 6,
                                    offset: Offset(0, 7.5),
                                    blurRadius: 11.25)
                              ],
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                  Text(
                                    'Address',
                                    style: GoogleFonts.ibmPlexSans(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Expanded(
                                    child: Text(
                                      '${client.address}',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.05,
                                vertical: height * 0.02),
                            width: width * 0.85,
                            height: height * 0.07,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xff2a824d).withOpacity(0.1),
                                    spreadRadius: 6,
                                    offset: Offset(0, 7.5),
                                    blurRadius: 11.25)
                              ],
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                  Text(
                                    'Date Posted',
                                    style: GoogleFonts.ibmPlexSans(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Expanded(
                                    child: Text(
                                      '${order.date.day}/${order.date.month}/${order.date.year}',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.05),
                          child: Row(
                            children: [
                              Visibility(
                                visible: order.status != 2,
                                child: Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      switch (order.status) {
                                        case 0: // Pending
                                          context
                                              .read<OrderProvider>()
                                              .updateOrder(
                                                  context, 1, order.orderId);

                                          break;
                                        case 1: // Ongoing
                                          context
                                              .read<OrderProvider>()
                                              .updateOrder(
                                                  context, 2, order.orderId);

                                          break;
                                        default:
                                          print(
                                              'Unknown order status: ${order.status}'); // Log warning or display error message
                                          break;
                                      }
                                    },
                                    child: Center(
                                      child: Container(
                                        height: height * 0.06,
                                        child: Center(
                                          child: Text(
                                            order.status == 0
                                                ? "Approve Order"
                                                : "Mark as Completed",
                                            style: GoogleFonts.ibmPlexSans(
                                                fontSize: 14,
                                                color: Colors.white),
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            color: Palette.primary),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: order.status != 2,
                                child: SizedBox(
                                  width: width * 0.05,
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    await context
                                        .read<OrderProvider>()
                                        .updateOrder(
                                            context, -1, order.orderId);
                                  },
                                  child: Center(
                                    child: Container(
                                      height: height * 0.06,
                                      child: Center(
                                        child: Text(
                                          order.status == 0
                                              ? "Decline Order"
                                              : order.status == 2
                                                  ? 'delete order'
                                                  : "Cancel Order",
                                          style: GoogleFonts.ibmPlexSans(
                                              fontSize: 14,
                                              color: Colors.white),
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          color: Colors.red),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        )
                      ],
                    ),
                  ),
                );
              });
            });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: height * 0.01),
        padding: EdgeInsets.symmetric(vertical: height * 0.01),
        width: width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color(0xff2a824d).withOpacity(0.1),
                spreadRadius: 6,
                offset: Offset(0, 7.5),
                blurRadius: 11.25)
          ],
        ),
        child: Column(
          children: [
            ListTile(
              title: Text(
                "${order.title}",
                style: GoogleFonts.ibmPlexSans(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                  '${order.date.day}/${order.date.month}/${order.date.year} : ${order.date.hour}: ${order.date.minute}'),
              trailing: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05, vertical: height * 0.01),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Palette.primary),
                child: Text(
                  'View details',
                  style: GoogleFonts.ibmPlexSans(color: Colors.white),
                ),
              ),
            ),
            ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Ordered By: ',
                            style: GoogleFonts.ibmPlexSans(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          TextSpan(
                            text: '${client.fullName}',
                            style:
                                GoogleFonts.ibmPlexSans(color: Palette.primary),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Address: ',
                            style: GoogleFonts.ibmPlexSans(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          TextSpan(
                            text: '${order.adress}',
                            style: GoogleFonts.ibmPlexSans(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                trailing: Image.network(
                  "${category.image}",
                  width: width * 0.1,
                ))
          ],
        ),
      ),
    ));
  }

  //****************************** user Card ******************************************
  static Widget userCard(BuildContext context, MyUser client) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.95,
      padding: EdgeInsets.symmetric(vertical: height * 0.02),
      margin: EdgeInsets.symmetric(vertical: height * 0.01),
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
      child: Row(
        children: [
          Spacer(),
          CircleAvatar(
            child: Center(
                child: Text(
              '${client.fullName[0].toUpperCase()}',
              style: GoogleFonts.ibmPlexSans(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 24),
            )),
            backgroundColor: Palette.primary,
            radius: 25,
          ),
          Spacer(),
          Container(
            width: width * 0.2,
            child: Text(
              "${client.fullName.toUpperCase()}",
              style: GoogleFonts.ibmPlexSans(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Spacer(),
          Container(
            height: height * 0.1,
            child: RotatedBox(
              quarterTurns: 1,
              child: Divider(
                color: Palette.primary,
                thickness: 1,
              ),
            ),
          ),
          Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: GoogleFonts.ibmPlexSans(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: 'Current Orders: ',
                      style: GoogleFonts.ibmPlexSans(
                          fontWeight: FontWeight.bold), // Bold style
                    ),
                    TextSpan(
                      // text: "${context.read<OrderProvider>().clients.length}",
                      text:
                          '${context.read<OrderProvider>().allorders.where((order) => ((order.status == 0 || order.status == 1) && order.userId.id == client.uid)).toList().length}',
                      style: GoogleFonts.ibmPlexSans(
                          fontWeight: FontWeight.normal,
                          color: Colors.blue.shade600), // Normal style
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.ibmPlexSans(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: 'Phone: ',
                      style: GoogleFonts.ibmPlexSans(
                          fontWeight: FontWeight.bold), // Bold style
                    ),
                    TextSpan(
                      text: '${client.phoneNumber}',
                      style: GoogleFonts.ibmPlexSans(
                          fontWeight: FontWeight.normal,
                          color: Palette.primary), // Normal style
                    ),
                  ],
                ),
              ),
              Container(
                width: width * 0.4,
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.ibmPlexSans(
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: 'Address: ',
                        style: GoogleFonts.ibmPlexSans(
                            fontWeight: FontWeight.bold), // Bold style
                      ),
                      TextSpan(
                        text: '${client.address}',
                        style: GoogleFonts.ibmPlexSans(
                            fontWeight: FontWeight.normal,
                            color: Colors.grey.shade600), // Normal style
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }

  void showSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Center(
        child:
            Text(message, style: MYText().mytextStyle(color: Colors.white)),
      ),
      backgroundColor: isError ? Colors.red : Palette.primary,
      behavior: SnackBarBehavior.floating,
    ));
  }
}
