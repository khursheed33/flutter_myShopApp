import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {
  final String producId;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  ProductDetails({
    this.title,
    this.description,
    this.price,
    this.imageUrl,
    this.producId,
  });
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 390,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
              child: Container(
                height: 220,
                width: MediaQuery.of(context).size.width - 20,
                child: Hero(
                  tag: id,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 160,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 40,
              ),
              width: 350,
              height: 207,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 111,
                    child: SingleChildScrollView(
                      child: Text(
                        description,
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.grey[200],
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 50,
            right: 50,
            child: Chip(
              backgroundColor: Colors.teal[50],
              padding: const EdgeInsets.symmetric(vertical: 4),
              label: Chip(
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                label: Text(
                  "\$${price.toString()}",
                  style: TextStyle(
                      letterSpacing: 3,
                      fontSize: 18,
                      color: Colors.grey[100],
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
