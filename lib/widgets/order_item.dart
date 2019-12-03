import 'dart:math';

import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import '../providers/orders.dart' as odi;

class OrderItem extends StatefulWidget {
  final odi.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
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
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.datetime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.all(16),
              height: min(widget.order.products.length * 20.0 + 60.0, 180.0),
              child: ListView(
                children: widget.order.products
                    .map(
                      (product) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(
                              product.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Text(
                              '\$${product.price} x${product.quantity}',
                              style: TextStyle(
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
    );
  }
}
