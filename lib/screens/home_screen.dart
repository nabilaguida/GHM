import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenhousemaintenance/models/category.dart';
import 'package:greenhousemaintenance/providers/categoriesProvider.dart';
import 'package:greenhousemaintenance/providers/orderProvider.dart';
import 'package:greenhousemaintenance/screens/settings/settings_screen.dart';
import 'package:greenhousemaintenance/utils/styles.dart';
import 'package:provider/provider.dart';
import '../generated/l10n.dart';
import '../models/order.dart';
import 'Orders/myOrdersScreen.dart';
import 'Orders/orderCreation.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  List<MyOrder> myorders = [];
  List<Category> categories = [];
  bool fetched = false;

  @override
  void initState() {
    // TODO: implement initState
    getOrdersByUser();
    super.initState();
  }

  getOrdersByUser() async {
    myorders = await context.read<OrderProvider>().getOrdersByUser();
    categories = await context.read<CategoriesProvider>().getCategories();
    setState(() {
      fetched = true;
    });
  }

  bool arabicLocal() {
    return Intl.getCurrentLocale() == 'ar';
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: !fetched
            ? Center(
                child: Container(
                  width: width * 0.3,
                  child: LinearProgressIndicator(
                    color: Colors.green.shade900,
                  ),
                ),
              )
            : Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/backgroundfinal.jpg"),
                        fit: BoxFit.fitWidth)),
                child: Column(
                  children: [
                    SizedBox(height: height*0.04,),
                    Container(
                      height: height * 0.28,
                      width: width,
                      child: Column(
                        children: [
                          Container(
                            height: height * 0.09,
                            width: width * 0.85,
                            child: Row(
                              children: [
                                Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Image.asset(
                                      "assets/logo white-8.png",
                                      width: width * 0.2,
                                    )),
                                Spacer(),
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SettingsScreen()));
                                    },
                                    icon: Container(
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        child: Icon(
                                          Icons.settings,
                                          color: Colors.green.shade900,
                                        )))
                              ],
                            ),
                          ),
                          Spacer(
                          ),
                          Container(
                            height: height * 0.15,
                            width: width * 0.85,
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text('${S.of(context).welcome_word}',
                                        style: MYText().mytextStyle(
                                            fontSize: 28,
                                            color: Colors.white70)),
                                    Text(
                                        "${firebaseAuth.currentUser!.displayName!.split(' ').first.toUpperCase()}",
                                        style: MYText().mytextStyle(
                                            fontSize: 22,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 2))
                                  ],
                                ),
                                Spacer(),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyOrdersScreen(
                                                  orders: myorders,
                                                ))),
                                    child: Container(
                                      width: width * 0.32,
                                      height: height * 0.056,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white70
                                                  .withOpacity(0.6),
                                              width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
                                      child: Center(
                                        child: Container(
                                          width: width * 0.3,
                                          height: height * 0.045,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              color: Colors.white
                                                  .withOpacity(0.15)),
                                          child: Center(
                                            child: Text(
                                                '${S.of(context).My_orders}',
                                                style: MYText().mytextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w400,
                                                    fontSize: 16)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30))),
                        child: RefreshIndicator(
                          onRefresh: () async {
                            getOrdersByUser();
                          },
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
                                          '${S.of(context).Available_Services}',
                                          style: MYText().mytextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.05),
                                child: GridView.count(
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    crossAxisCount: 3, // Number of columns
                                    childAspectRatio:
                                        1, // Aspect ratio of each child (square in this case)
                                    mainAxisSpacing:
                                        width * 0.03, // Spacing between rows
                                    crossAxisSpacing: width *
                                        0.03, // Spacing between columns
                                    children: categories
                                        .map((category) => (!category.visible)
                                            ? Container(
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Color(
                                                                  0xff2a824d)
                                                              .withOpacity(
                                                                  0.1),
                                                          spreadRadius: 6,
                                                          offset:
                                                              Offset(0, 7.5),
                                                          blurRadius: 11.25)
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                    color: Colors.white),
                                                child: Stack(
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Opacity(
                                                          opacity: 0.5,
                                                          child: Container(
                                                            height:
                                                                height * 0.04,
                                                            width:
                                                                height * 0.04,
                                                            decoration:
                                                                BoxDecoration(
                                                                    image:
                                                                        DecorationImage(
                                                              fit: BoxFit
                                                                  .contain,
                                                              image:
                                                                  NetworkImage(
                                                                "${category.image}",
                                                              ),
                                                            )),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              height * 0.02,
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      width *
                                                                          0.02),
                                                          child: Center(
                                                            child: Text(
                                                                "${arabicLocal() ? category.titleAr : category.title}",
                                                                // "Mohamed Nabil Aguida",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: MYText().mytextStyle(
                                                                    height:
                                                                        1.2,
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Align(
                                                      alignment: Alignment
                                                          .center, // Position at top center
                                                      child: Container(
                                                        width: double
                                                            .infinity, // Take full width of parent
                                                        height: height *
                                                            0.04, // Adjust height as needed
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400),
                                                        child: Center(
                                                          child: Text(
                                                            '${S.of(context).Coming_Soon}',
                                                            style: MYText()
                                                                .mytextStyle(
                                                              fontSize: 10,
                                                              color: Colors
                                                                  .white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (contex) =>
                                                            OrderCreationScreen(
                                                              category:
                                                                  category,
                                                            ))),
                                                child: Container(
                                                  // padding: EdgeInsets.symmetric(horizontal: width*0.02,vertical: height*0.01),
                                                  decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Color(0xff2a824d)
                                                                .withOpacity(
                                                                    0.1),
                                                            spreadRadius: 6,
                                                            offset: Offset(
                                                                0, 7.5),
                                                            blurRadius: 11.25)
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15)),
                                                      color: Colors.white),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        height: height * 0.05,
                                                        width: height * 0.05,
                                                        decoration:
                                                            BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                          fit: BoxFit
                                                              .contain,
                                                          image: NetworkImage(
                                                            "${category.image}",
                                                          ),
                                                        )),
                                                      ),
                                                      SizedBox(
                                                        height: height * 0.01,
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    width *
                                                                        0.02),
                                                        child: Center(
                                                          child: Text(
                                                            "${arabicLocal() ? category.titleAr : category.title}",
                                                            // "Mohamed Nabil Aguida",
                                                            textAlign:
                                                                TextAlign
                                                                    .center,
                                                            style: MYText().mytextStyle( height:
                                                            1.2,
                                                                fontSize:
                                                                11,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w600)
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ))
                                        .toList()),
                              ),
                              SizedBox(
                                height: height * 0.04,
                              ),
                              myorders.isEmpty
                                  ? Container()
                                  : Center(
                                      child: Container(
                                        width: width * 0.9,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyOrdersScreen(
                                                          orders: myorders,
                                                        )));
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                  '${S.of(context).Recent_activities}',
                                                  style: MYText().mytextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              Spacer(),
                                              Text("${S.of(context).See_All}",
                                                  style: MYText().mytextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                                size: 12,
                                                color: Colors.blue,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: height * 0.01),
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  children: myorders
                                      .take(5)
                                      .map((order) => Center(
                                              child: Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: height * 0.007),
                                            width: width * 0.9,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
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
                                            child: ListTile(
                                              title: Text(
                                                "${order.title}",
                                                style:
                                                    GoogleFonts.ibmPlexSans(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                                  '${order.date.day}/${order.date.month}/${order.date.year} ${order.date.hour}:${order.date.minute}'),
                                              trailing: order.status == 0
                                                  ? Text(
                                                      '${S.of(context).pending_status}',
                                                      style: MYText()
                                                          .mytextStyle(
                                                          color: Colors
                                                              .red
                                                              .shade600,
                                                          fontSize:
                                                          14)
                                                    )
                                                  : order.status == 1
                                                      ? Text(
                                                          '${S.of(context).ongoing_status}',
                                                          style: MYText()
                                                              .mytextStyle(
                                                              color: Colors
                                                                  .red
                                                                  .shade600,
                                                              fontSize:
                                                              14),
                                                        )
                                                      : order.status == 2
                                                          ? Text(
                                                              '${S.of(context).completed_status}',
                                                              style: MYText()
                                                                  .mytextStyle(
                                                                  color: Colors
                                                                      .red
                                                                      .shade600,
                                                                  fontSize:
                                                                  14)
                                                            )
                                                          : Text(
                                                              '${S.of(context).canceled_status}',
                                                              style: MYText()
                                                                  .mytextStyle(
                                                                      color: Colors
                                                                          .red
                                                                          .shade600,
                                                                      fontSize:
                                                                          14)),
                                            ),
                                          )))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ));
  }
}
