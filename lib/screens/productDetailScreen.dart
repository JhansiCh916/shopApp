import 'package:flutter/material.dart';
import '../providers/productProviders.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // ProductDetailScreen(this.title);

  static const routeName = "productDetail";
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final loadedProduct = Provider.of<ProductsProvider>(context, listen: false).productFoundById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(loadedProduct.imageUrl, fit: BoxFit.cover,),
            ),
            SizedBox(height: 10,),
            Container(
              child: Text("\$${loadedProduct.price}"),
            ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              width: double.infinity,
              child: Text("${loadedProduct.description}",textAlign: TextAlign.center,),
            ),
          ],
        ),
      ),
    );
  }
}
