import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class GridItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final scaffold = Scaffold.of(context);
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          // Navigating to Products Detail Page
          Navigator.of(context).pushNamed(
            GridItemDetailScreen.routeName,
            arguments: product.id,
          );
        },
        child: GridTile(
          child: Hero(
            tag: product.id,
            child: FadeInImage.assetNetwork(
              placeholder: "assets/images/placeholder-image.png",
              image: product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
              builder: (context, product, _) => IconButton(
                color: Theme.of(context).accentColor,
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
                onPressed: () =>
                    product.toggleFavoriteIcon(authData.token, authData.userId),
              ),
            ),
            title: Text(product.title),
            trailing: IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                // Always show current snackbar
                Scaffold.of(context).removeCurrentSnackBar();
                // Adding snack bar when item added to cart
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Item Added to Cart"),
                    action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () {
                        // Remove Currently added item
                        cart.removeItemWithSnackbar(product.id);
                      },
                    ),
                  ),
                );
                cart.addItemToCart(
                  productId: product.id,
                  productTitle: product.title,
                  productPrice: product.price,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
