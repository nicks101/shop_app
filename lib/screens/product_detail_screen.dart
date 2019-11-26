import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product_detail';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;

    final _loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(_loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Image.network(
                _loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 15),
            Text(
              'Product Name : ${_loadedProduct.title}',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 15),
            Text(
              'Product Price : ${_loadedProduct.price}',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '${_loadedProduct.description}',
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
