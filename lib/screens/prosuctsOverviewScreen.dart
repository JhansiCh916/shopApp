import 'package:flutter/material.dart';
import '../providers/productProviders.dart';
import '../widgets/productsGrid.dart';
import 'package:provider/provider.dart';


enum FilterOptions {
  Favourites,
  ShowAll,
}

class ProductsOverViewScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final productContainer = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("MY SHOP"),
        actions: [
          PopupMenuButton(itemBuilder: (_) => [
            PopupMenuItem(child: Text("Your Favourites"), value: FilterOptions.Favourites,),
            PopupMenuItem(child: Text("Your ShowAll"), value: FilterOptions.ShowAll,),
          ],
          icon: Icon(Icons.more_vert),onSelected: (FilterOptions selectValue) {
            if (selectValue == FilterOptions.Favourites) {
              productContainer.showFavouritesProductsOny();
            } else {
              productContainer.showAll();
            }
            print("selectValue");
            },)
        ],
      ),
      body: ProductsGrid(),
    );
  }
}
