import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/orders.dart' as odi;

class OrderItem extends StatefulWidget {
  final odi.OrderItem order;

  const OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _expanded
          ? min(widget.order.products.length * 20.0 + 200.0, 250.0)
          : 125,
      child: Card(
        margin: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                '\$${widget.order.amount}',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.datetime),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(8),
              height: _expanded
                  ? min(widget.order.products.length * 20.0 + 60.0, 120.0)
                  : 0,
              child: ListView(
                children: widget.order.products
                    .map(
                      (product) => Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(
                              product.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '\$${product.price} x${product.quantity}',
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
