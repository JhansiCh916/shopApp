import 'package:flutter/material.dart';
import '../screens/editProductScreen.dart';
import '../widgets/appDrawer.dart';
import '../widgets/userProducts.dart';
import '../providers/productProviders.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/userProductsScreen";

  Future<void> refreshProducts(BuildContext context) async {
   await Provider.of<ProductsProvider>(context, listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add your product"),
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).pushNamed(EditProductScreen.routeName);
          }, icon: const Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: refreshProducts(context),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting ? Center(child: CircularProgressIndicator(),) : RefreshIndicator(
          onRefresh: () => refreshProducts(context),
          child: Consumer<ProductsProvider>(
            builder: (ctx, productsData, _) => Padding(
              padding: EdgeInsets.all(10),
              child: ListView.builder(itemBuilder: (_, index) =>
                  UserproductsItem(product.items[index].id,product.items[index].title, product.items[index].imageUrl, product.deleteProducts),
              itemCount: product.items.length,),

            ),
          ),
        ),
      ),
    );
  }
}
