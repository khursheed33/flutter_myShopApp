import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItems extends StatelessWidget {
  final String id;
  final String title;
  final String productId;
  final double price;
  final int quantity;
  CartItems({
    this.id,
    this.title,
    this.productId,
    this.price,
    this.quantity,
  });
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: ValueKey(id),
      background: Container(
        margin: EdgeInsets.all(6),
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 35,
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text("Are you sure?"),
                content: Text("This is going to delete your item!"),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                    child: Text("Cancel"),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                    child: Text("Confirm"),
                  ),
                ],
              );
            });
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(
                  child: Text('\$$price'),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity)}'),
            trailing: Container(
              // color: Colors.red,
              width: 70,
              height: 60,
              child: Row(
                children: [
                  Text(
                    '$quantity x',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Icon(
                          Icons.arrow_drop_up,
                          size: 25,
                        ),
                        onTap: () {
                          cart.addItemToCart(
                            productId: productId,
                            productTitle: title,
                            productPrice: price,
                            productQuantity: quantity,
                          );
                        },
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.arrow_drop_down,
                          size: 25,
                        ),
                        onTap: () {},
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
