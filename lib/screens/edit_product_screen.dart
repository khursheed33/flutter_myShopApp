import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    imageUrl: '',
    price: 0,
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  bool isInit = true;
  var _isLoading = false;
  /* 
  - To avoid memory leak for above variables 
  - Use dispose method and dispose after use.
   */
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void didChangeDependencies() {
    if (isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;

      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    var validate = _formKey.currentState.validate();
    if (!validate) {
      print("Validation Failed");
      return;
    }
    _formKey.currentState.save();
    // set is loading to true

    setState(() {
      _isLoading = true;
    });

/* 
  - one await always going to be executed.
  - then the last setState() will execute.
 */
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      // Try block runs to test the condition
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        // Catch block to throw an error
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("An error occured!"),
            content: Text("Something went wrong :(."),
            actions: [
              FlatButton(
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Okay"),
              ),
            ],
          ),
        );
      }
      // finally {
      //   // set is loading to false
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    // set is loading to false
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit and Create Product"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveForm(),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: "Title"),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: value,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          price: _editedProduct.price,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter a valid title";
                        }
                        if (value.length < 2) {
                          return "The title length must be greater than 2";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'].toString(),
                      decoration: InputDecoration(labelText: "Price"),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          price: double.parse(value),
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter a price.";
                        }
                        if (double.tryParse(value) == null) {
                          return "Please enter a valid price";
                        }
                        if (double.parse(value) <= 0) {
                          return "The price must be greater than zero.";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: "Description"),
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      maxLines: 3,
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          description: value,
                          imageUrl: _editedProduct.imageUrl,
                          price: _editedProduct.price,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    // Preview Image
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 5),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: _imageUrlController.text.isNotEmpty
                              ? FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Text("Add an Image"),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: "Image URL"),
                            controller: _imageUrlController,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                imageUrl: value,
                                price: _editedProduct.price,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                              );
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Enter a valid image URL";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
