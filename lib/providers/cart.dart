import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quatity;
  final double price;

  CartItem({
    @required this.id,
    @required this.price,
    @required this.title,
    @required this.quatity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get cartLength {
    return _items.length;
  }

  double get totalAmount {
    double _totalAmount = 0.0;
    _items.forEach((key, cartItem) {
      _totalAmount += cartItem.price * cartItem.quatity;
    });
    return _totalAmount;
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          price: existingItem.price,
          quatity: existingItem.quatity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quatity: 1,
        ),
      );
    }
    notifyListeners();
  }
}
