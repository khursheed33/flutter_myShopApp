import 'package:flutter/material.dart';
import 'package:myshop/widgets/drawer.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_items.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    print("Building Orders");
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future:
            Provider.of<Orders>(context, listen: false).fetchAndSetOrdered(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (dataSnapshot.error != null) {
            print("ErrorType:: ${dataSnapshot.error}");
            print(dataSnapshot);
            return Center(child: Text("An internet error occured!"));
          } else {
            return Consumer<Orders>(builder: (ctx, orderData, _) {
              return orderData == null
                  ? Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            child: Text(
                              "Orders not available. Click here to",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          FittedBox(
                            child: FlatButton(
                              textColor: Theme.of(context).primaryColor,
                              child: Text(
                                "Order Now",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed('/');
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: orderData.orders.length,
                      itemBuilder: (ctx, index) =>
                          OrderItems(orderData.orders[index]),
                    );
            });
          }
        },
      ),
    );
  }
}
