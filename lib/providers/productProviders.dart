
import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/httpException.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //     'p1',
    //     'Red Shirt',
    //     'A red shirt - it is pretty red!',
    //     29.99,
    //     'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    //     true
    // ),
    // Product(
    //     'p2',
    //     'Trousers',
    //     'A nice pair of trousers.',
    //     59.99,
    //     'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    //     false
    // ),
    // Product(
    //     'p3',
    //     'Yellow Scarf',
    //     'Warm and cozy - exactly what you need for the winter.',
    //     19.99,
    //     'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    //     true
    // ),
    // Product(
    //     'p4',
    //     'A Pan',
    //     'Prepare any meal you want.',
    //     49.99,
    //     'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    //     false
    // ),
  ] ;

  final String authToken;
  final String userId;


  ProductsProvider(this.authToken, this._items, this.userId);
  // var _showFavouritesOnly = false;

  List<Product> get items {
    // if (_showFavouritesOnly) {
    //   return _items.where((item) => item.isFavourite).toList();
    // }
    return [..._items];
  }


  List<Product> get favouriteItems {
    return items.where((favItem) => favItem.isFavourite).toList();
  }

  Product productFoundById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavouritesProductsOny() {
  //   _showFavouritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavouritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="createrId"&equalTo="$userId"' : '';
    final url = Uri.parse(
        'https://flutterdemo-ba6c1-default-rtdb.asia-southeast1.firebasedatabase.app/Products.json?auth=$authToken&$filterString');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        // print(json.decode(response.body));
        loadedProducts.add(Product(
          prodId,prodData['title'],prodData['description'],prodData['price'],prodData['imageUrl'],prodData['isFavourite'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error){
      throw error;
    }
  }

  Future <void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://flutterdemo-ba6c1-default-rtdb.asia-southeast1.firebasedatabase.app/Products.json?auth=$authToken');
    // _items.add(value)
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavourite': product.isFavourite,
            'createrId': userId,
          }));
      print(json.decode(response.body));
      final newProduct = Product(json.decode(response.body)['name'],
          product.title, product.description, product.price, product.imageUrl, product.isFavourite);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
    return Future.value();
  }

  Future<void> updateProduct(String id, Product newProduct) async {

    final prodIndex = _items.indexWhere((prod) => prod.id == id);

    if (prodIndex >= 0){
      final url = Uri.parse(
          'https://flutterdemo-ba6c1-default-rtdb.asia-southeast1.firebasedatabase.app/Products/$id.json?auth=$authToken');
      await http.patch(url, body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'imageUrl': newProduct.imageUrl,
        'price': newProduct.price,
        'isFavourite': newProduct.isFavourite
      }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {

    }
  }

  Future<void> deleteProducts(String id) async {
    final url = Uri.parse(
        'https://flutterdemo-ba6c1-default-rtdb.asia-southeast1.firebasedatabase.app/Products/$id.json?auth=$authToken');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];

    final response = await http.delete(url);
    _items.removeAt(existingProductIndex);
    notifyListeners();
    print(response.statusCode);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could not delete product");
    }
    existingProduct = null;

  }
}
