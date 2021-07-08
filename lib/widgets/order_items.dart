import 'dart:math';
import 'package:flutter/material.dart';
import '../providers/orders.dart';
import 'package:intl/intl.dart';

class OrderItems extends StatefulWidget {
  final OrderItem orders;
  OrderItems(this.orders);

  @override
  _OrderItemsState createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  var _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _isExpanded
          ? min((widget.orders.products.length * 20.0) + 130.0, 250)
          : 96,
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text(
                "\$${widget.orders.amount.toStringAsFixed(2)}",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              subtitle: Row(
                children: [
                  Text(
                    DateFormat('dd/mm/yyyy').format(widget.orders.time),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.schedule,
                    color: Colors.grey[700],
                    size: 15,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(DateFormat("hh:mm").format(widget.orders.time))
                ],
              ),
              trailing: IconButton(
                icon: Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 35,
                ),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
            ),
            // if (_isExpanded)
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              height: _isExpanded
                  ? min((widget.orders.products.length * 10.0) + 50.0, 100)
                  : 0,
              child: ListView(
                children: widget.orders.products
                    .map(
                      (orderItem) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${orderItem.title}",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: Colors.grey[800]),
                          ),
                          Text(
                            "${orderItem.quantity}x  \$${orderItem.price}",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
