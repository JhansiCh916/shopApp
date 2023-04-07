import 'package:flutter/material.dart';
import '../widgets/appDrawer.dart';
import '../providers/cart.dart';
import 'cartView.dart';
import '../providers/productProviders.dart';
import '../widgets/productsGrid.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  Favourites,
  ShowAll,
}

class ProductsOverViewScreen extends StatefulWidget {
  @override
  State<ProductsOverViewScreen> createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  var _showFavaouritesOnly = false;

  @override
  Widget build(BuildContext context) {
    // final productContainer = Provider.of<ProductsProvider>(context);
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("MY SHOP"),
        actions: [
          PopupMenuButton(
              itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: FilterOptions.Favourites,
                      child: Text("Your Favourites"),
                    ),
                    const PopupMenuItem(
                      value: FilterOptions.ShowAll,
                      child: Text("Your ShowAll"),
                    ),
                  ],
              icon: const Icon(Icons.more_vert),
              onSelected: (FilterOptions selectValue) {
                setState(
                  () {
                    if (selectValue == FilterOptions.Favourites) {
                      // productContainer.showFavouritesProductsOny();
                      _showFavaouritesOnly = true;
                    } else {
                      // productContainer.showAll();
                      _showFavaouritesOnly = false;
                    }
                  },
                );
              }),
          Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                    child: ch,
                    label: Text(cart.itemCount.toString()),
                  ),
              child: IconButton(
                  icon: Icon(Icons.shopping_cart), onPressed: () {
                    Navigator.of(context).pushNamed(CartView.routeName);
              })),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showFavaouritesOnly),
    );
  }
}
