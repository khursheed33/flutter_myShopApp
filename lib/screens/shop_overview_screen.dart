import 'package:flutter/material.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/widgets/drawer.dart';
import '../screens/cart_screen.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widgets/badge.dart';

import '../widgets/products_grid.dart';

enum FilterOptions { Favorites, All }

class ShopOverviewScreen extends StatefulWidget {
  static const routeName = '/shop-overview';
  @override
  _ShopOverviewScreenState createState() => _ShopOverviewScreenState();
}

class _ShopOverviewScreenState extends State<ShopOverviewScreen> {
  var _isFavoriteScreen = false;

  Future<void> _refreshShopOverview(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProduct();
  }
  // var _isInit = true;
  // var _isLoading = false;
  // @override
  // void initState() {
  // This won't works here
  // Provider.of<Products>(context).fetchAndSetProduct();

  // This helper method will make it work
  // Future.delayed(Duration.zero).then((_) {
  /* In this pattern the listen:false is must to get the data from server otherwise it throws an error */
  //   Provider.of<Products>(context, listen: false).fetchAndSetProduct();
  // });
  //   super.initState();
  // }

  // Alternative way of fetching the data from the server;
  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     Provider.of<Products>(context).fetchAndSetProduct().then((_) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     });
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    // final cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: [
            PopupMenuButton(
              onSelected: (FilterOptions selectedVal) {
                setState(() {
                  if (selectedVal == FilterOptions.Favorites) {
                    _isFavoriteScreen = true;
                  } else {
                    _isFavoriteScreen = false;
                  }
                });
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text("Favorites Only"),
                  value: FilterOptions.Favorites,
                ),
                PopupMenuItem(
                  child: Text("Show All"),
                  value: FilterOptions.All,
                ),
              ],
            ),
            // Adding Cart Badge
            Consumer<Cart>(
              builder: (_, cartData, ch) => Badge(
                child: ch,
                value: Provider.of<Cart>(context, listen: false)
                    .itemCount
                    .toString(),
              ),
              child: IconButton(
                color: Colors.white,
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            ),
          ],
          title: Text("MyShop"),
        ),
        drawer: AppDrawer(),
        body: RefreshIndicator(
          onRefresh: () => _refreshShopOverview(context),
          child: FutureBuilder(
            future: Provider.of<Products>(context, listen: false)
                .fetchAndSetProduct(),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (dataSnapshot.error != null) {
                print(dataSnapshot.error);
                print(dataSnapshot);
                return Center(
                  child: Text("An error occured! ${dataSnapshot.error}"),
                );
              } else {
                return ProductsGrid(_isFavoriteScreen);
              }
            },
          ),
        ));
  }
}
