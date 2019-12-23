import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'dart:convert';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;

  OrderItem({
    @required this.id,
    @required this.datetime,
    @required this.amount,
    @required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrders(List<CartItem> cartProducts, double total) async {
    final url = 'https://flutter-shop-app-60a6a.firebaseio.com/orders.json';
    final timeStamp = DateTime.now();

    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timeStamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quatity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );

    _orders.insert(
      0,
      OrderItem(
        datetime: timeStamp,
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
