import 'package:flutter/material.dart';
import 'package:my_shop/screens/editProductScreen.dart';
import '../providers/orders.dart';
import '../screens/orderScreen.dart';
import '../screens/userProductScreen.dart';
import 'screens/cartView.dart';
import '../screens/prosuctsOverviewScreen.dart';
import '../screens/productDetailScreen.dart';
import '../providers/productProviders.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiProvider(providers: [
        ChangeNotifierProvider(
        create:(ctx) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
        create: (ctx) => Cart(),),
    ChangeNotifierProvider(
    create: (ctx) => Orders(),),
    ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange
        ),
        home: ProductsOverViewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          CartView.routeName: (context) => CartView(),
          OrderScreen.routeName: (context) => OrderScreen(),
          UserProductsScreen.routeName: (context) => UserProductsScreen(),
          EditProductScreen.routeName: (context) => EditProductScreen(),
        },
      ),
    );
  }
}