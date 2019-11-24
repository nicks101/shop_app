import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;

  ProductItem({
    this.title,
    this.imageUrl,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        title: Text(
          title,
          textAlign: TextAlign.center,
        overflow: TextOverflow.fade,
        ),
        backgroundColor: Colors.black54,
        leading: IconButton(
          icon: Icon(Icons.favorite),
          onPressed: () {},
        ),
        trailing: IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () {},
        ),
      ),
    );
  }
}
