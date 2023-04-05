import 'package:flutter/material.dart';
import 'package:my_shop/providers/product.dart';
import '../providers/productProviders.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add your product"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.add))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(itemBuilder: itemBuilder),
      ),
    );
  }
}
