import 'package:flutter/material.dart';
import '../widgets/appDrawer.dart';
import '../providers/orders.dart' show Orders;
import 'package:provider/provider.dart';
import '../widgets/orderItem.dart';

class OrderScreen extends StatelessWidget {

  static const routeName = "/orders";

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your orders"),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(itemBuilder: (ctx, index) {
        return OrderItem(orderData.orders[index]);

      }, itemCount: orderData.orders.length,),
    );
  }
}
