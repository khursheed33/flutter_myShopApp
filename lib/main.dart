import 'package:flutter/material.dart';
import 'package:myshop/helpers/custom_route.dart';
import 'package:provider/provider.dart';
// User Imports
import './screens/splash_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/manage_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/shop_overview_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => null,
          update: (ctx, authData, previousProducts) => Products(
            authData.token,
            authData.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => null,
          update: (ctx, authData, previousOrders) => Orders(
            authData.token,
            authData.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "MyShop",
          theme: ThemeData(
              primarySwatch: Colors.teal,
              accentColor: Colors.orange,
              fontFamily: 'Lato',
              canvasColor: Colors.teal[50],
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              })),
          home: authData.isAuth
              ? ShopOverviewScreen()
              : FutureBuilder(
                  future: authData.tryAutoLogin(),
                  builder: (ctx, snapData) =>
                      snapData.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ShopOverviewScreen.routeName: (ctx) => ShopOverviewScreen(),
            GridItemDetailScreen.routeName: (ctx) => GridItemDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            ManageProductScreen.routeName: (ctx) => ManageProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
