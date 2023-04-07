import 'package:flutter/material.dart';
import '../providers/productProviders.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../widgets/ProductsItem.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFav;

  ProductsGrid(this.showFav);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products = showFav ? productsData.favouriteItems : productsData.items;
    // final productItems = productsData.items;
    return GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem(
              // productItems[index].id,
              // productItems[index].title,
              // productItems[index].imageUrl
          ),
        ));
  }
}


