import 'dart:html';

import 'package:flutter/material.dart';
import '../widgets/appDrawer.dart';
import '../providers/orders.dart' show Orders;
import 'package:provider/provider.dart';
import '../widgets/orderItem.dart';

class OrderScreen extends StatefulWidget {

  static const routeName = "/orders";

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your orders"),
      ),
      drawer: AppDrawer(),
      body: isLoading ? CircularProgressIndicator() : ListView.builder(itemBuilder: (ctx, index) {
        return OrderItem(orderData.orders[index]);

      }, itemCount: orderData.orders.length,),
    );
  }
}
