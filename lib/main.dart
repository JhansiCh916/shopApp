import 'package:flutter/material.dart';
import '../providers/auth.dart';
import 'package:my_shop/providers/product.dart';
import '../screens/auth_screen.dart';
import '../screens/editProductScreen.dart';
import '../screens/splash_screen.dart';
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
      ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: (ctx) => ProductsProvider("", [],""),
        update: (ctx, auth, previousProducts) => ProductsProvider(auth.token ?? "", previousProducts == null ? [] : previousProducts.items, auth.userId ?? ""),
        ),
        ChangeNotifierProvider(
        create: (ctx) => Cart(),),
    ChangeNotifierProxyProvider<Auth, Orders>(create: (ctx) =>Orders("", [],""),
        update: (ctx, auth, previousOrders) => Orders(auth.token ?? "", previousOrders == null ? [] : previousOrders.orders,auth.userId ?? "")),
    ],
      child: Consumer<Auth>(builder: (ctx, auth, _) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange
        ),
        home: auth.isAuth ?
        ProductsOverViewScreen() :  FutureBuilder(builder: (ctx, authResultSnapshot) =>
        authResultSnapshot.connectionState == ConnectionState.waiting ?
        SplashScreen() : AuthScreen(), future: auth.tryAutoLogIn(),),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          CartView.routeName: (context) => CartView(),
          OrderScreen.routeName: (context) => OrderScreen(),
          UserProductsScreen.routeName: (context) => UserProductsScreen(),
          EditProductScreen.routeName: (context) => EditProductScreen(),
        },
      ),)
    );
  }
}