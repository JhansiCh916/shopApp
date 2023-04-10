import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(this.id, this.title, this.description, this.price, this.imageUrl,
      this.isFavourite);

  void isTogglefavourite(String authToken, String userId) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url = Uri.parse(
        'https://flutterdemo-ba6c1-default-rtdb.asia-southeast1.firebasedatabase.app/UserFavourites/$userId/$id.json?auth=$authToken');
    try {
      await http.put(url, body: json.encode( isFavourite));
    } catch(error) {
      isFavourite = oldStatus;
      notifyListeners();
    }
  }
}
