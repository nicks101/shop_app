import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(
      context,
      listen: false,
    );
    final cart = Provider.of<Cart>(
      context,
      listen: false,
    );
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        footer: GridTileBar(
          title: Text(
            product.title,
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
          ),
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () {
                product.toggleFavoriteStatus(
                  authData.token!,
                  authData.userId!,
                );
              },
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              cart.addItem(
                product.id!,
                product.price,
                product.title,
              );
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Added item to cart!'),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id!);
                    },
                  ),
                ),
              );
            },
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(7.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                blurRadius: 20.0,
                spreadRadius: 5.0,
                offset: const Offset(10, 10),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  ProductDetailScreen.routeName,
                  arguments: product.id,
                );
              },
              child: Hero(
                tag: product.id!,
                child: FadeInImage(
                  placeholder:
                      const AssetImage('assets/images/product-placeholder.png'),
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
