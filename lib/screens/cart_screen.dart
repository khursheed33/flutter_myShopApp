import 'package:flutter/material.dart';
import 'package:myshop/widgets/drawer.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widgets/cart_items.dart' as myCart;
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Total Amount",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '\$${cart.cartTotalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          Divider(),
          // Listing out the List of Cart Items
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                return myCart.CartItems(
                  id: cart.items.values.toList()[index].id,
                  title: cart.items.values.toList()[index].title,
                  productId: cart.items.keys.toList()[index],
                  price: cart.items.values.toList()[index].price,
                  quantity: cart.items.values.toList()[index].quantity,
                );
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              "ORDER NOW",
              style: TextStyle(
                  color: widget.cart.cartTotalAmount <= 0
                      ? Colors.grey
                      : Colors.green[600],
                  fontWeight: FontWeight.bold),
            ),
      onPressed: (widget.cart.cartTotalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).orderNow(
                widget.cart.items.values.toList(),
                widget.cart.cartTotalAmount,
              );
              setState(() {
                _isLoading = false;
              });
              // Clearing Cart Items
              widget.cart.clearOrders();
            },
    );
  }
}
