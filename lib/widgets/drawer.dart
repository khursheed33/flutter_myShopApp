import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myshop/screens/manage_product_screen.dart';
import 'package:myshop/screens/orders_screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Container(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 10,
                ),
                child: Text(
                  "Manage Your Shopping !",
                  style: TextStyle(
                    color: Theme.of(context).primaryColorLight,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.shop_two,
                  size: 35,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  "Shop",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text("Go to Shopping"),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.payment,
                  size: 35,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  "Orders",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text("Get to Payments"),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(OrdersScreen.routeName);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  size: 35,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  "Manage Products",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text("Edit, Delete and Add Products"),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(ManageProductScreen.routeName);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.exit_to_app,
                  size: 35,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  "Log Out",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/');
                  Provider.of<Auth>(context, listen: false).logOut();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
