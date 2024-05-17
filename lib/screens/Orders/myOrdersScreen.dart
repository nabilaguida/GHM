import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenhousemaintenance/providers/orderProvider.dart';
import 'package:greenhousemaintenance/utils/Cards.dart';
import 'package:greenhousemaintenance/utils/styles.dart';
import 'package:greenhousemaintenance/utils/thems.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';
import '../../models/order.dart';
import 'package:intl/intl.dart';

class MyOrdersScreen extends StatefulWidget {
  final List<MyOrder> orders;
  const MyOrdersScreen({super.key, required this.orders});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
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
                  fit: BoxFit.cover)),
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
                          alignment: arabicLocal() ? Alignment.topRight :Alignment.centerLeft,
                          child: Text(
                            '${S.of(context).My_orders}',
                            style: MYText().mytextStyle(  fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)
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
                    SizedBox(height: height*0.02,),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selected_tab = 0;
                              });
                            },
                            child: Container(
                              height: height * 0.05,
                              decoration: selected_tab == 0
                                  ? BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Palette.primary,
                                              width: 3)))
                                  : BoxDecoration(),
                              margin: EdgeInsets.symmetric(
                                  horizontal: width * 0.05),
                              child: Center(
                                child: Text(
                                  "${S.of(context).Ongoing_orders}",
                                  style: MYText().mytextStyle(     fontWeight: FontWeight.w600,
                                      fontSize: 14)
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selected_tab = 1;
                              });
                            },
                            child: Container(
                              height: height * 0.05,
                              decoration: selected_tab == 1
                                  ? BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Palette.primary,
                                              width: 3)))
                                  : BoxDecoration(),
                              margin: EdgeInsets.symmetric(
                                  horizontal: width * 0.05),
                              child: Center(
                                child: Text(
                                  "${S.of(context).Completed_orders}",
                                  style: MYText().mytextStyle(  fontWeight: FontWeight.w600,
                                      fontSize: 14)
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    widget.orders.isEmpty ? Center(child: Image.asset(arabicLocal() ? "assets/arabic.png":"assets/Asset 2-8.png",width: width*0.8,),) :
                    ListView.separated(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: selected_tab == 0
                          ? widget.orders
                              .where((order) =>
                                  order.status == 0 || order.status == 1)
                              .length
                          : widget.orders
                              .where((order) =>
                                  order.status != 0 && order.status != 1)
                              .length,
                      itemBuilder: (context, index) {
                        final orders = selected_tab == 0
                            ? widget.orders
                                .where((order) =>
                                    order.status == 0 || order.status == 1)
                                .toList()
                            : widget.orders
                                .where((order) =>
                                    order.status != 0 && order.status != 1)
                                .toList();
                        return Cards.orderCard(context, orders[index]);
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(
                            height: height*0.02,
                          ), // Optional separator between items
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
