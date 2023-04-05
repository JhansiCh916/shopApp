import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartView extends StatelessWidget {
  const CartView({Key? key}) : super(key: key);
  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Total", style: TextStyle(fontSize: 20,
                      fontWeight: FontWeight.normal, color: Colors.black),),
                  Spacer(),
                  // SizedBox(width: 10,),
                  Chip(label: Text("\$${cart.totalAmount}")),
                  TextButton(onPressed: () {}, child: Text("Order Now"))
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          ListView.builder(itemBuilder: (ctx,i) =>
              CartView(id: cart.items[i].id,
              title: cart.items[i].title,
              price: cart.items[i].price,
              quantity: cart.items[i].quantity)
            ,itemCount: cart.itemCount,)
        ],
      ),
    );
  }
}
