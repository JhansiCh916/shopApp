import 'package:flutter/material.dart';
import '../widgets/productsGrid.dart';

class ProductsOverViewScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MY SHOP"),
      ),
      body: ProductsGrid(),
    );
  }
}
