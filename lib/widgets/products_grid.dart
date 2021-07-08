import 'package:flutter/material.dart';
import 'product_items.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  final bool isFavs;

  ProductsGrid(this.isFavs);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context, listen: false);
    final products = isFavs ? productData.favoriteItems : productData.items;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) => ChangeNotifierProvider.value(
                value: products[index],
                child: GridItems(),
              )),
    );
  }
}
