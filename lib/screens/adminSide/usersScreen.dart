import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenhousemaintenance/providers/categoriesProvider.dart';
import 'package:greenhousemaintenance/providers/orderProvider.dart';
import 'package:greenhousemaintenance/screens/adminSide/adminUserOrdrs.dart';
import 'package:provider/provider.dart';

import '../../utils/Cards.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Users"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.people,
                color: Colors.green,
              ))
        ],
      ),
      body: ListView(
          shrinkWrap: true,
          children: context
              .read<OrderProvider>()
              .clients
              .map((client) => Center(
                    child:
                        GestureDetector(
                        onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminUserOrdersScreen(
                             orders: context.read<OrderProvider>().allorders.where((order) => ((order.status == 0 || order.status == 1) && order.userId.id == client.uid) ).toList(),
                             categories: context.read<CategoriesProvider>().categories,
                             client: client,
                             icon: Icons.reorder))) ;
                        },
                        child: Cards.userCard(context, client)),
                  ))
              .toList()),
    );
  }
}
