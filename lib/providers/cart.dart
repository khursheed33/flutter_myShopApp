import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:myshop/models/http_exception.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  // final String authToken;
  // Cart(this.authToken, this._items);
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

// Fetch cart items from sever

  double get cartTotalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  Future<void> addItemToCart(
      {String productId,
      double productPrice,
      String productTitle,
      int productQuantity}) async {
    // const url = 'https://myshop-7aab6-default-rtdb.firebaseio.com/cart.json';

    // get all existing products in the cart
    // final cartItems = await http.get(url);
    // final extractedItems =
    //     json.decode(cartItems.body) as Map<String, dynamic>;
    // final List<CartItem> loadedCart = [];
    // extractedItems.forEach(
    //   (cartItemId, cartItem) {
    //     loadedCart.add(
    //       CartItem(
    //         id: cartItemId,
    //         title: cartItem['title'],
    //         quantity: cartItem['quantity'],
    //         price: cartItem['price'],
    //       ),
    //     );
    //   },
    // );

// If product does not existing then post a product
    // await http.post(url,
    //     body: json.encode({
    //       'title': productTitle,
    //       'id': productId,
    //       'price': productPrice,
    //       'quantity': productQuantity,
    //     }));
    if (_items.containsKey(productId)) {
      // change quantity...
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: productTitle,
          price: productPrice,
          quantity: 1,
        ),
      );
    }
    notifyListeners();

    //  catch (error) {
    //   throw HttpException("Product cannot be added to cart!");
    // }
  }

// Decreasing logic for cart screen
  // void decreaseItemByOne(String productId, int productQuantity) {
  //   if (_items.containsKey(productId)) {
  //     _items.update(productId, (existingProduct) {
  //       return CartItem(
  //         id: productId,
  //         title: existingProduct.title,
  //         quantity: existingProduct.quantity - 1,
  //         price: existingProduct.price,
  //       );
  //     });
  //   } else {
  //     print("Something went wrong!");
  //   }
  // }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeItemWithSnackbar(String productId) {
    // if product doesn't exists
    if (!(_items.containsKey(productId))) {
      return;
    }
    // When same product added more than once - then reduce one from previous
    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          quantity: existingItem.quantity - 1,
          price: existingItem.price,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearOrders() {
    _items = {};
    notifyListeners();
  }
}
