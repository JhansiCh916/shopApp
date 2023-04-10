import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({ required this.id,  required this.amount,  required this.products,  required this.dateTime});

}

class Orders with ChangeNotifier {

  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this._orders, this.userId);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://flutterdemo-ba6c1-default-rtdb.asia-southeast1.firebasedatabase.app/Orders/$userId.json?auth=$authToken');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedOrders = [];
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((ordId, ordData) {
        loadedOrders.add(OrderItem(id: ordId,
            amount: ordData['amount'],
            products: (ordData['products'] as List<dynamic>).map((item) =>
                CartItem(id: item['id'], title: item['title'], price: item['price'], quantity: item['quantity'])).toList(),
            dateTime: DateTime.parse(ordData['dateTime'])));
      });
      _orders = loadedOrders;
      notifyListeners();
    } catch (error){
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts,double total) async {
    final url = Uri.parse(
        'https://flutterdemo-ba6c1-default-rtdb.asia-southeast1.firebasedatabase.app/Orders.json?auth=$authToken');
    final timeStamp = DateTime.now();
    final response = await http.post(url, body: json.encode({
      'amount': total,
      'dateTime': DateTime.now().toIso8601String(),
      'products': cartProducts.map((cartProduct) => {
        'id': cartProduct.id,
        'title': cartProduct.title,
        'quantity': cartProduct.quantity,
        'price': cartProduct.price
      }).toList(),
    }));
    _orders.insert(0, OrderItem(id: json.decode(response.body)['name'],
        amount: total, products: cartProducts, dateTime: DateTime.now()));
    notifyListeners();
  }

}