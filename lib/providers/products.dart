import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get showFavoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts({bool filterByUser = false}) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://flutter-shop-app-60a6a.firebaseio.com/products.json?auth=$authToken&$filterString';
    final response = await http.get(Uri.parse(url));

    if (response.body.isEmpty) return;

    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    url =
        'https://flutter-shop-app-60a6a.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
    final favouriteResponse = await http.get(Uri.parse(url));
    final favouriteData =
        json.decode(favouriteResponse.body) as Map<String, dynamic>?;

    final List<Product> _loadedProduct = [];

    extractedData.forEach((String prodId, data) {
      final prodData = data as Map<String, dynamic>;
      _loadedProduct.add(
        Product(
          id: prodId,
          price: prodData['price'] as double,
          description: prodData['description'] as String,
          imageUrl: prodData['imageUrl'] as String,
          title: prodData['title'] as String,
          isFavorite: favouriteData != null &&
              favouriteData[prodId] != null &&
              favouriteData[prodId] as bool,
        ),
      );
    });
    _items = _loadedProduct;
    notifyListeners();
  }

  Future<void> addProducts(Product product) async {
    final url =
        'https://flutter-shop-app-60a6a.firebaseio.com/products.json?auth=$authToken';

    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'title': product.title,
        'price': product.price,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'creatorId': userId,
      }),
    );

    final _newProduct = Product(
      id: (json.decode(response.body) as Map<String, dynamic>)['name']
          as String,
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    );
    _items.add(_newProduct);
    notifyListeners();
  }

  Future<void> updateProducts(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((product) => id == product.id);

    if (prodIndex >= 0) {
      final url =
          'https://flutter-shop-app-60a6a.firebaseio.com/products/$id.json?auth=$authToken';

      await http.patch(
        Uri.parse(url),
        body: json.encode({
          'title': newProduct.title,
          'price': newProduct.price,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
        }),
      );

      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProducts(String id) async {
    final url =
        'https://flutter-shop-app-60a6a.firebaseio.com/products/$id.json?auth=$authToken';

    final existingProductIndex =
        _items.indexWhere((product) => product.id == id);
    Product? existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
