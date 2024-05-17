import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenhousemaintenance/providers/orderProvider.dart';
import 'package:greenhousemaintenance/screens/adminSide/adminOrdersScreen.dart';
import 'package:greenhousemaintenance/screens/adminSide/categoriesScreen.dart';
import 'package:greenhousemaintenance/screens/adminSide/usersScreen.dart';
import 'package:greenhousemaintenance/screens/settings/settings_screen.dart';
import 'package:greenhousemaintenance/utils/thems.dart';
import 'package:provider/provider.dart';
import '../../models/User.dart';
import '../../models/category.dart';
import '../../models/order.dart';
import '../../providers/categoriesProvider.dart';
import '../Orders/myOrdersScreen.dart';

class HomeCard {
  IconData image;
  String title;
  Widget? page;

  HomeCard({required this.title, required this.image, this.page});
}

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  List<MyOrder> myorders = [];

  List<HomeCard> cards = [
    HomeCard(title: "Users", image: Icons.people, page: UsersScreen()),
    HomeCard(
        title: "Pending Orders",
        image: Icons.hourglass_empty,
        ),
    HomeCard(
        title: "Ongoing Orders", image: Icons.watch_later),
    HomeCard(
        title: "Completed Orders",
        image: Icons.check_circle,
       ),
  ];
  List<MyUser> clients = [] ;
  bool fetched = false;
  List<Category> mycategories = [];


  @override
  void initState() {
    // TODO: implement initState
    getHome();
    super.initState();
  }

  getHome() async {
    await context.read<OrderProvider>().getAdminHome();
    myorders = context.read<OrderProvider>().allorders;
    clients =  context.read<OrderProvider>().clients;
    await context.read<CategoriesProvider>().getCategories();

    setState(() {
      mycategories = context.read<CategoriesProvider>().categories ;
      fetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
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
                      Container(
                        height: height * 0.32,
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
                              flex: 2,
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
                                      Text(
                                        'Welcome',
                                        style: GoogleFonts.ibmPlexSans(
                                            fontSize: 28,
                                            color: Colors.white70),
                                      ),
                                      Text(
                                        "${firebaseAuth.currentUser!.displayName!.split(' ').first.toUpperCase()}",
                                        style: GoogleFonts.ibmPlexSans(
                                            fontSize: 22,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 2),
                                      )
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
                                                  CategoriesScreen())),
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
                                                'Categories',
                                                style: GoogleFonts.ibmPlexSans(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16),
                                              ),
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
                            color: Colors.green,
                            onRefresh:   ()async{
                              getHome();
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
                                          'Manage App',
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
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.05),
                                  child: GridView.count(
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    crossAxisCount: 2, // Number of columns
                                    childAspectRatio:
                                        1, // Aspect ratio of each child (square in this case)
                                    mainAxisSpacing:
                                        width * 0.05, // Spacing between rows
                                    crossAxisSpacing:
                                        width * 0.05, // Spacing between columns
                                    children: List.generate(
                                        4,
                                        (index) => GestureDetector(
                                              onTap: () {
                                                if(index == 0){
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (contex) =>
                                                          cards[index].page!));
                                                }else{
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminordersScreen(categories: mycategories,clients: clients,orders: myorders,page: index,icon: cards[index].image,))) ;
                                                }

                                              },
                                              child: Container(
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
                                                        BorderRadius.all(
                                                            Radius.circular(15)),
                                                    color: Colors.white),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Center(
                                                        child: Icon(
                                                      cards[index].image,
                                                      size: 30,
                                                      color:
                                                          Palette.primary,
                                                    )),
                                                    SizedBox(
                                                      height: height * 0.01,
                                                    ),
                                                    Center(
                                                      child: Container(
                                                        width: width * 0.3,
                                                        child: Text(
                                                          "${cards[index].title}",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts.ibmPlexSans(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )), // Generate 9 empty containers
                                  ),
                                ),
                                // SizedBox(
                                //   height: height * 0.02,
                                // ),
                                // myorders.isEmpty
                                //     ? Container()
                                //     : Center(
                                //         child: Container(
                                //           width: width * 0.9,
                                //           child: GestureDetector(
                                //             onTap: () {
                                //               Navigator.push(
                                //                   context,
                                //                   MaterialPageRoute(
                                //                       builder: (context) =>
                                //                           MyOrdersScreen(
                                //                             orders: myorders,
                                //                           )));
                                //             },
                                //             child: Row(
                                //               children: [
                                //                 Text(
                                //                   'Recent activities',
                                //                   style: GoogleFonts.ibmPlexSans(
                                //                       fontSize: 16,
                                //                       fontWeight:
                                //                           FontWeight.w600),
                                //                 ),
                                //                 Spacer(),
                                //                 Text(
                                //                   "See All",
                                //                   style: GoogleFonts.ibmPlexSans(
                                //                       color: Colors.blue,
                                //                       fontWeight:
                                //                           FontWeight.bold),
                                //                 ),
                                //                 Icon(
                                //                   Icons
                                //                       .arrow_forward_ios_outlined,
                                //                   size: 12,
                                //                   color: Colors.blue,
                                //                 )
                                //               ],
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                // SizedBox(
                                //   height: height * 0.015,
                                // ),
                                // ListView(
                                //   shrinkWrap: true,
                                //   physics: ScrollPhysics(),
                                //   children: myorders
                                //       .map((order) => Center(
                                //               child: Container(
                                //             width: width * 0.9,
                                //             decoration: BoxDecoration(
                                //               color: Colors.white,
                                //               boxShadow: [
                                //                 BoxShadow(
                                //                     color: Color(0xff2a824d)
                                //                         .withOpacity(0.1),
                                //                     spreadRadius: 6,
                                //                     offset: Offset(0, 7.5),
                                //                     blurRadius: 11.25)
                                //               ],
                                //             ),
                                //             child: ListTile(
                                //               title: Text(
                                //                 "${order.title}",
                                //                 style: GoogleFonts.ibmPlexSans(
                                //                     fontWeight: FontWeight.bold),
                                //               ),
                                //               subtitle: Text('${order.date}'),
                                //               trailing: order.status == 0
                                //                   ? Text(
                                //                       'Pending',
                                //                       style: GoogleFonts.ibmPlexSans(
                                //                           color: Colors
                                //                               .orange.shade600,
                                //                           fontSize: 14),
                                //                     )
                                //                   : order.status == 1
                                //                       ? Text(
                                //                           'Ongoing',
                                //                           style: GoogleFonts.ibmPlexSans(
                                //                               color: Colors
                                //                                   .blue.shade600,
                                //                               fontSize: 14),
                                //                         )
                                //                       : order.status == 2
                                //                           ? Text(
                                //                               'Completed',
                                //                               style: GoogleFonts.ibmPlexSans(
                                //                                   color: Colors
                                //                                       .green
                                //                                       .shade600,
                                //                                   fontSize: 14),
                                //                             )
                                //                           : Text(
                                //                               'Canceled',
                                //                               style: GoogleFonts.ibmPlexSans(
                                //                                   color: Colors
                                //                                       .red
                                //                                       .shade600,
                                //                                   fontSize: 14),
                                //                             ),
                                //             ),
                                //           )))
                                //       .toList(),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
    );
  }
}
