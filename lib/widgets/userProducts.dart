import 'package:flutter/material.dart';
import 'package:my_shop/providers/productProviders.dart';
import 'package:provider/provider.dart';
import '../screens/editProductScreen.dart';

class UserproductsItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final Function deleteHandler;

  UserproductsItem(this.id,this.title, this.imageUrl, this.deleteHandler);

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: id);
              },
              icon: Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<ProductsProvider>(context, listen: false)
                      .deleteProducts(id);
                } catch (error){
                  scaffold.showSnackBar(SnackBar(content: Text("Deleting failed")),);
                }
              },
              icon: Icon(Icons.delete),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
