import 'package:flutter/material.dart';

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(this.id, this.title, this.description, this.price,this.imageUrl, this.isFavourite);

  void isTogglefavourite() {
    isFavourite = !isFavourite;
    notifyListeners();
}
}