import 'package:flutter/material.dart';
import 'package:my_shop/screens/orderScreen.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widgets/cartItem.dart' as ci;
import '../providers/orders.dart';

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
                  Chip(label: Text("\$${cart.totalAmount.toStringAsFixed(2)}")),
                  TextButton(onPressed: () {
                    Navigator.of(context).pushNamed(OrderScreen.routeName);
                    Provider.of<Orders>(context, listen: false).addOrder(cart.items.values.toList(),
                        cart.totalAmount);
                    cart.clear();
                  }, child: Text("Order Now"))
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(itemBuilder: (ctx,i) =>
                ci.CartItem(id: cart.items.values.toList()[i].id,
                productCartId: cart.items.keys.toList()[i],
                title: cart.items.values.toList()[i].title,
                price: cart.items.values.toList()[i].price,
                quantity: cart.items.values.toList()[i].quantity)
              ,itemCount: cart.items.length,),
          )
        ],
      ),
    );
  }
}
