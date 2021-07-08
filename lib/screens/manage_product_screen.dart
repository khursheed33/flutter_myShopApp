import 'package:flutter/material.dart';
import 'package:myshop/screens/edit_product_screen.dart';
import 'package:myshop/widgets/drawer.dart';

import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/manage_product_item.dart';

class ManageProductScreen extends StatelessWidget {
  static const routeName = '/manage-products';
  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    // final products = Provider.of<Products>(context);
    // final productData = products.items;
    print("build running....");
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Products"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProduct(context),
        builder: (ctx, dataSnap) => dataSnap.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => _refreshProduct(context),
                child: Consumer<Products>(
                  builder: (ctx, productData, _) => Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: productData.items.length > 0
                        ? ListView.builder(
                            itemCount: productData.items.length,
                            itemBuilder: (_, index) {
                              return Column(
                                children: [
                                  ManageProductItem(
                                    id: productData.items[index].id,
                                    title: productData.items[index].title,
                                    imageUrl: productData.items[index].imageUrl,
                                  ),
                                  Divider(),
                                ],
                              );
                            })
                        : Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("There is no product to manage, - "),
                                FlatButton(
                                  textColor: Colors.blue,
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(EditProductScreen.routeName);
                                  },
                                  child: Text("Add Some Product!"),
                                )
                              ],
                            ),
                          ),
                  ),
                ),
              ),
      ),
    );
  }
}
