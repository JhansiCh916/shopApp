import 'package:flutter/material.dart';
import '../providers/productProviders.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../widgets/ProductsItem.dart';

class ProductsGrid extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final productItems = productsData.items;
    return GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: productItems.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemBuilder: (ctx, index) => ChangeNotifierProvider(
          create: (context) => productItems[index],
          child: ProductItem(
              // productItems[index].id,
              // productItems[index].title,
              // productItems[index].imageUrl
          ),
        ));
  }
}


