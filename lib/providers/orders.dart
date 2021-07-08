import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime time;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.time,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String orderToken;
  final String userId;

  Orders(this.orderToken, this.userId, this._orders);
  List<OrderItem> get orders {
    return [..._orders];
  }

// Fetching Orders
  Future<void> fetchAndSetOrdered() async {
    final url =
        'https://myshop-7aab6-default-rtdb.firebaseio.com/orders/$userId.json?auth=$orderToken';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedOrders = json.decode(response.body) as Map<String, dynamic>;
    // print("Products: $extractedOrders");
    // print("Orders: $_orders");
    if (extractedOrders == null) {
      return;
    }
    extractedOrders.forEach((orderId, orderItem) {
      print("Testing");
      // (orderItem['products'])
      //     .map((item) => print("ID: ${item['title']}"))
      //     .toList();
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: double.parse(orderItem['amount']),
          time: DateTime.parse(orderItem['time']),
          products: (orderItem['products'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'],
                  ))
              .toList(),
        ),
      );
      print("Full Block Ran");
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();

    // print("After: $_orders");
  }

// Ordering Cart Items
  Future<void> orderNow(List<CartItem> cartProducts, double total) async {
    final url =
        'https://myshop-7aab6-default-rtdb.firebaseio.com/orders/$userId.json?auth=$orderToken';
    final timestamp = DateTime.now();
    // Adding order items
    final response = await http.post(
      url,
      body: json.encode(
        {
          'amount': total.toStringAsFixed(4),
          'time': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price
                  })
              .toList(),
        },
      ),
    );

    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        time: timestamp,
      ),
    );
    notifyListeners();
  }
}
