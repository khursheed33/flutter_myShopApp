import 'dart:convert';
import 'package:http/http.dart' as http;
// HTTPS ABOVE
import 'package:flutter/material.dart';
import 'package:myshop/models/http_exception.dart';
import '../providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
    // Product(
    //   id: 'p5',
    //   title: 'T-Shirt',
    //   description: 'LeeCooper cozy t-shirt, Feels better than other.',
    //   price: 29.49,
    //   imageUrl:
    //       'https://images.unsplash.com/photo-1596609548086-85bbf8ddb6b9?ixid=MXwxMjA3fDB8MHxzZWFyY2h8Mjh8fHNob3BwaW5nfGVufDB8fDB8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    // ),
    // Product(
    //   id: 'p6',
    //   title: 'Warm T-shirt',
    //   description:
    //       'The best winter dress for Snow. Making the body warm even in the snow falls.',
    //   price: 69.49,
    //   imageUrl:
    //       'https://images.unsplash.com/photo-1582719188393-bb71ca45dbb9?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MzJ8fHNob3BwaW5nfGVufDB8fDB8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    // ),
    // Product(
    //   id: 'p7',
    //   title: 'Hat Girl',
    //   description:
    //       'A hat is a head covering which is worn for various reasons, including protection against weather conditions, ceremonial reasons such as university graduation, religious reasons, safety, or as a fashion accessory.',
    //   price: 75.49,
    //   imageUrl:
    //       'https://images.unsplash.com/photo-1558191053-8edcb01e1da3?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NDF8fHNob3BwaW5nfGVufDB8fDB8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    // ),
    // Product(
    //   id: 'p8',
    //   title: 'Mask for Men',
    //   description:
    //       "A mask is an object normally worn on the face, typically for protection, disguise, performance, or entertainment. ... They are usually worn on the face, although they may also be positioned for effect elsewhere on the wearer's body.",
    //   price: 45.76,
    //   imageUrl:
    //       'https://images.unsplash.com/photo-1597873015544-bbf5f6517659?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NjB8fHNob3BwaW5nfGVufDB8fDB8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    // ),
    // Product(
    //   id: 'p9',
    //   title: 'EUME Bag',
    //   description:
    //       "EUME Brizo 32 Ltrs with 3 Compartment Water Resistance Nylon Fabric School,Collage,Office and Travel for Men,Women Casual Backpack (Grey).",
    //   price: 35.76,
    //   imageUrl:
    //       'https://images-na.ssl-images-amazon.com/images/I/91SckaCfucL._SL1500_.jpg',
    // ),
    // Product(
    //   id: 'p10',
    //   title: 'Formal Shoes',
    //   description: "Formal Shoes - Centrino Men\'s 3372 Formal Shoes",
    //   price: 35.76,
    //   imageUrl:
    //       'https://images-na.ssl-images-amazon.com/images/I/719ac9bSG8L._UL1500_.jpg',
    // ),
    // Product(
    //   id: 'p11',
    //   title: 'SweatShirt',
    //   description:
    //       "Veirdo Men's Cotton Hooded Sweatshirt , Care Instructions: Regular hand wash/machine wash, Do not bleach!.",
    //   price: 35.76,
    //   imageUrl:
    //       'https://images-na.ssl-images-amazon.com/images/I/61XYswsucyL._UL1440_.jpg',
    // ),
  ];

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    /*  
    - Returning a copy of list items to be used wherever you listen to the provider listener.
    - Spread operator used to avoid the list error.
     */
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }
// Find by ID

  findById(String id) {
    return items.firstWhere((prod) => prod.id == id);
  }

// Fething Data from server
  Future<void> fetchAndSetProduct([bool filterByUser = false]) async {
    final filterLogic =
        filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://myshop-7aab6-default-rtdb.firebaseio.com/products.json?auth=$authToken$filterLogic';
    try {
      final response = await http.get(url);
      // print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      // Getting data from the server
      url =
          'https://myshop-7aab6-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];

      // adding the received products to loadedProduct List

      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            price: prodData['price'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false,
          ),
        );
        _items = loadedProducts;
        notifyListeners();
      });
    } catch (error) {
      throw error;
    }
  }

// Return a Future to await the product untill the async work done.
  Future<void> addProduct(Product product) async {
    // Store url of db to a variable
    final url =
        'https://myshop-7aab6-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    // Perform post request
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'creatorId': userId,
        }),
      );

      final newProduct = Product(
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        id: json.decode(response.body)['name'],
      );
      // Inserting at beginning
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      // If any problem occured in the session of creating product
      // It may be internet problen or anything else
      // Then this will catch the error and throws to the respective listener.
      // print("Error" + error);
      throw error;
    }
  }

// Updating Existing product
  Future<void> updateProduct(String productId, Product newProduct) async {
    final productIndex = _items.indexWhere((prod) => prod.id == productId);
    if (productIndex >= 0) {
      final url =
          'https://myshop-7aab6-default-rtdb.firebaseio.com/products/$productId.json?=auth$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[productIndex] = newProduct;
      notifyListeners();
    }
  }

  // Deleting Products
  Future<void> deleteProduct(String productId) async {
    final url =
        'https://myshop-7aab6-default-rtdb.firebaseio.com/products/$productId.json?auth=$authToken';
    final existingProductIndex =
        _items.indexWhere((prod) => prod.id == productId);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    // Deleting product from server
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Product Cannot be deleted!");
    }

    existingProduct = null;
    // print("Product Deleted Successfully");
    // Catching Errors and rolling back
  }
}
