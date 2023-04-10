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
                  OrderButton(cart: cart)
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: widget.cart.totalAmount <= 0 ? null : ()  async {
      setState(() {
        isLoading = true;
      });
      Navigator.of(context).pushNamed(OrderScreen.routeName);
      await Provider.of<Orders>(context, listen: false).addOrder(widget.cart.items.values.toList(),
          widget.cart.totalAmount);
      widget.cart.clear();
      setState(() {
        isLoading = false;
      });
    }, child: isLoading ? CircularProgressIndicator() : Text("Order Now"));
  }
}
