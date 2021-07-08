import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/screens/edit_product_screen.dart';

class ManageProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  ManageProductItem({this.id, this.title, this.imageUrl});
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text("Cannot be Deleted"),
                    ),
                  );
                }
                scaffold.showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red[900],
                    content: Text(
                      "Product Deleted Successfully!",
                      style: TextStyle(
                        color: Colors.teal[50],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
