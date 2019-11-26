import 'package:flutter/foundation.dart';

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

  void addOrders(
    List<CartItem> cartProducts,
    double total,
  ) {
    _orders.insert(
      0,
      OrderItem(
        datetime: DateTime.now(),
        id: DateTime.now().toString(),
        amount: total,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
