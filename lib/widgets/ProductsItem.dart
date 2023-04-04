import 'package:flutter/material.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import '../screens/productDetailScreen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  //
  // ProductItem(this.id,this.title,this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: product.id);
        },
        child: GridTile(child:
        Image.network(product.imageUrl, fit: BoxFit.cover,
        ),
          footer: GridTileBar(title:
          Text(product.title, textAlign: TextAlign.center,),
            backgroundColor: Colors.black87,
            leading: IconButton(icon: Icon(product.isFavourite ? Icons.favorite : Icons.favorite_border),onPressed: () {
              product.isTogglefavourite();
            },color: Theme.of(context).accentColor,),
            trailing: IconButton(icon: Icon(Icons.shopping_cart),onPressed: () {

          },color: Theme.of(context).accentColor,),
          ),
        ),
      ),
    );
  }
}
