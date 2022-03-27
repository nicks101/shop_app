import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;

  OrderItem({
    required this.id,
    required this.datetime,
    required this.amount,
    required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrders(List<CartItem> cartProducts, double total) async {
    final url =
        'https://flutter-shop-app-60a6a.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timeStamp = DateTime.now();

    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'amount': total,
        'dateTime': timeStamp.toIso8601String(),
        'products': cartProducts
            .map(
              (cp) => {
                'id': cp.id,
                'title': cp.title,
                'quantity': cp.quantity,
                'price': cp.price,
              },
            )
            .toList(),
      }),
    );

    _orders.insert(
      0,
      OrderItem(
        datetime: timeStamp,
        id: (json.decode(response.body) as Map<String, dynamic>)['name']
            as String,
        amount: total,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://flutter-shop-app-60a6a.firebaseio.com/orders/$userId.json?auth=$authToken';

    final response = await http.get(Uri.parse(url));
    final extractedData = json.decode(response.body) as Map<String, dynamic>?;

    if (extractedData == null) return;

    final List<OrderItem> _loadedOrders = [];

    extractedData.forEach((orderId, data) {
      final orderData = data as Map<String, dynamic>;
      _loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'] as double,
          datetime: DateTime.parse(orderData['dateTime'] as String),
          products: (orderData['products'] as List).map((orderItem) {
            final item = orderItem as Map<String, dynamic>;
            return CartItem(
              id: item['id'] as String,
              price: item['price'] as double,
              quantity: item['quantity'] as int? ?? 1,
              title: item['title'] as String,
            );
          }).toList(),
        ),
      );
    });
    _orders = _loadedOrders.reversed.toList();
    notifyListeners();
  }
}
