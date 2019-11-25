import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';

enum FilterOptions {
  ShowFavorites,
  ShowAll,
}

class ProductsOverviewScreen extends StatefulWidget {
  bool _showFavoritesOnly = false;

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.ShowFavorites) {
                  widget._showFavoritesOnly = true;
                } else {
                  widget._showFavoritesOnly = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.ShowFavorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.ShowAll,
              ),
            ],
          ),
        ],
      ),
      body: ProductsGrid(widget._showFavoritesOnly),
    );
  }
}
