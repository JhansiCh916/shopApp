import 'package:flutter/material.dart';
import '../screens/editProductScreen.dart';
import '../widgets/appDrawer.dart';
import '../widgets/userProducts.dart';
import '../providers/productProviders.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/userProductsScreen";

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add your product"),
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).pushNamed(EditProductScreen.routeName);
          }, icon: Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(itemBuilder: (_, index) =>
            UserproductsItem(product.items[index].id,product.items[index].title, product.items[index].imageUrl, product.deleteProducts),
        itemCount: product.items.length,),

      ),
    );
  }
}
