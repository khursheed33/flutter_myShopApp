import 'package:flutter/material.dart';
import 'package:myshop/widgets/produt_detail.dart';

import 'package:provider/provider.dart';
import '../providers/products.dart';

class GridItemDetailScreen extends StatelessWidget {
  static const routeName = 'grid-items';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final productsData = Provider.of<Products>(context).findById(productId);
    // print("Product : $productId\nProduct ID: ${productsData.id}");
    return Scaffold(
      appBar: AppBar(
        title: Text(productsData.title),
      ),
      body: ProductDetails(
        title: productsData.title,
        description: productsData.description,
        price: productsData.price,
        imageUrl: productsData.imageUrl,
      ),
    );
  }
}
