import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productCartId;
  final String title;
  final double price;
  final int quantity;

  CartItem({ required this.id,required this.productCartId, required this.title,  required this.price,  required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        child: Icon(Icons.delete),
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
      ),
      direction: DismissDirection.endToStart,
      // onDismissed: (direction) {
      //   Provider.of<Cart>(context, listen: false).removeItem(productCartId);
      // },
      confirmDismiss: (direction) {
        return showDialog(context: context, builder: (ctx) =>
            AlertDialog(content: Text("do you want remove item from the cart"),
              title: Text("Are you sure!"),
            actions: [TextButton(onPressed: () {
              Navigator.of(context).pop(false);
            }, child: Text("No")),
              TextButton(onPressed: () {
                Navigator.of(context).pop(true);
              }, child: Text("Yes"))
            ],));
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: ListTile(
            leading: CircleAvatar(child: FittedBox(child: Text("\$${price}")),),
            trailing: Text("\$$quantity"),
            title: Text("$title"),
            subtitle: Text("\$$id"),
          ),
        ),
      ),
    );
  }
}
