import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import '../providers/orders.dart' as odi;

class OrderItem extends StatelessWidget {
  final odi.OrderItem order;

  OrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${order.amount}'),
            subtitle:
                Text(DateFormat('dd mm yyyy hh:mm').format(order.datetime)),
            trailing: IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
