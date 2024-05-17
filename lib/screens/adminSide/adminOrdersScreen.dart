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

class AdminordersScreen extends StatefulWidget {
  final List<MyOrder> orders;
  final int page;
  final IconData icon;
  final List<MyUser> clients ;
  final List<Category> categories ;
  const AdminordersScreen(
      {super.key,
      required this.orders,
      required this.page,
        required this.clients ,
        required this.categories,
      required this.icon});

  @override
  State<AdminordersScreen> createState() => _AdminordersScreenState();
}

class _AdminordersScreenState extends State<AdminordersScreen> {
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
                height: height * 0.18,
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
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Clients Orders',
                            style: GoogleFonts.ibmPlexSans(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
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
                              widget.page == 1
                                  ? 'Pending Orders'
                                  : widget.page == 2
                                      ? 'Ongoing Orders'
                                      : 'Completed Orders',
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
                      children: widget.orders.where((order) => order.status == (widget.page-1) )
                          .map((order) => Cards.adminorderCard(context, order,widget.clients.firstWhere((client) => client.uid == order.userId.id),context.read<CategoriesProvider>().categories.firstWhere((category) => category.categoryId == order.category)))
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
