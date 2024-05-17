import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenhousemaintenance/providers/categoriesProvider.dart';
import 'package:greenhousemaintenance/providers/orderProvider.dart';
import 'package:greenhousemaintenance/utils/Cards.dart';
import 'package:provider/provider.dart';
import '../../models/User.dart';
import '../../models/category.dart';
import '../../models/order.dart';
import 'package:intl/intl.dart';

class AdminUserOrdersScreen extends StatefulWidget {
  final List<MyOrder> orders;
  final IconData icon;
  final MyUser client;
  final List<Category> categories;
  const AdminUserOrdersScreen(
      {super.key,
      required this.orders,
      required this.categories,
      required this.client,
      required this.icon});

  @override
  State<AdminUserOrdersScreen> createState() => _AdminUserOrdersScreenState();
}

class _AdminUserOrdersScreenState extends State<AdminUserOrdersScreen> {
  int selected_tab = 0;
  bool arabicLocal() {
    return Intl.getCurrentLocale() == 'ar';
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/backgroundfinal.jpg"),
                  fit: BoxFit.fitWidth)),
          child: Column(
            children: [
              Container(
                height: height * 0.34,
                width: width,
                child: Column(
                  children: [
                    Container(
                      height: height * 0.08,
                      width: width * 0.9,
                      child: Row(
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Spacer(),
                          // Center(child: Text('Client Orders',style: GoogleFonts.ibmPlexSans(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),))
                          // ,Spacer(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Cards.userCard(context, widget.client),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    InkWell(
                      onTap: () {
                        context.read<OrderProvider>().openWhatsAppChat(
                            'Hello this is Green House Maintenance team ...',
                            '${widget.client.phoneNumber}');
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: width * 0.025),
                        child: Container(
                          height: height * 0.065,
                          decoration: BoxDecoration(
                              color: Colors
                                  .white, // Adjust color as needed for button look
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
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
                                'Contact ${widget.client.fullName.toUpperCase()}',
                                style: GoogleFonts.ibmPlexSans(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                              Spacer(),
                            ],
                          )),
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30)),
                  color: Colors.white,
                ),
                child: ListView(
                  children: [
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Center(
                      child: Container(
                        width: width * 0.9,
                        child: Row(
                          children: [
                            Text(
                              'Current Orders',
                              style: GoogleFonts.ibmPlexSans(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Spacer(),
                            Icon(
                              widget.icon,
                              color: Colors.green.shade600,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    widget.orders.isEmpty ? Center(child: Image.asset(arabicLocal() ? "assets/arabic.png":"assets/Asset 2-8.png",width: width*0.8,),) :
                    ListView(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      children: widget.orders
                          .map((order) => Cards.adminorderCard(
                              context,
                              order,
                              widget.client,
                              context
                                  .read<CategoriesProvider>()
                                  .categories
                                  .firstWhere((category) =>
                                      category.categoryId == order.category)))
                          .toList(),
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
