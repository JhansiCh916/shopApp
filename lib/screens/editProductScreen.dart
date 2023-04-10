import 'package:flutter/material.dart';
import '../providers/product.dart';
import '../providers/productProviders.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/editproductScreen";

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final priceFOcusNode = FocusNode();
  final descriptionfocusNode = FocusNode();
  final imageController = TextEditingController();
  final imageFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var editedProduct = Product("", "", "", 0, "", false);
  var init = true;
  var isLoading = false;

  var initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };

  @override
  void initState() {
    // TODO: implement initState
    imageController.addListener(submitUrl);
    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (init) {
      final productId = ModalRoute.of(context)?.settings.arguments as String?;
      if (productId != null) {
        editedProduct = Provider.of<ProductsProvider>(context, listen: false).productFoundById(productId);
        initValues = {
          'title': editedProduct.title,
          'description': editedProduct.description,
          'price': (editedProduct.price).toString(),
          'imageUrl': ''
        };
        imageController.text = editedProduct.imageUrl;
      }
    }
    init = false;
    super.didChangeDependencies();
  }

  Future <void> saveForm() async {
    final productId = ModalRoute.of(context)?.settings.arguments as String?;
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();
    setState(() {
      isLoading = true;
    });
    if (productId != null) {
      await Provider.of<ProductsProvider>(context, listen: false).updateProduct(editedProduct.id,editedProduct);
      Navigator.of(context).pop();
      setState(() {
        isLoading = false;
      });
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false).addProduct(editedProduct);
      } catch(error) {
        return showDialog(context: context, builder: (ctx) {
          return AlertDialog(
            title: Text("There is a error"),content: Text("Something went wrong"),
            actions: [
              TextButton(onPressed: () {
                setState(() {
                  isLoading = false;
                });
                Navigator.of(ctx).pop();

              }, child: Text("okay"))
            ],
          );
        });
      } finally {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }

  }

  void submitUrl() {
    if (!imageFocusNode.hasFocus) {
      if (!imageController.text.startsWith('http') &&
              !imageController.text.startsWith('https') ||
          (!imageController.text.endsWith('.jpg') &&
              !imageController.text.endsWith('.png') &&
              !imageController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    imageFocusNode.removeListener(submitUrl);
    priceFOcusNode.dispose();
    descriptionfocusNode.dispose();
    imageController.dispose();
    imageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit product"),
        actions: [IconButton(onPressed: saveForm, icon: Icon(Icons.save))],
      ),
      body: isLoading ? Center(child: CircularProgressIndicator(
        backgroundColor: Colors.grey,
      ),) : Padding(
        padding: EdgeInsets.all(8),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: initValues["title"],
                decoration: InputDecoration(labelText: "Title"),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(priceFOcusNode);
                },
                onSaved: (value) {
                  editedProduct = Product(
                      editedProduct.id,
                      value ?? "",
                      editedProduct.description,
                      editedProduct.price,
                      editedProduct.imageUrl,
                      editedProduct.isFavourite);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter title";
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                  initialValue: initValues["price"],
                decoration: const InputDecoration(labelText: "Price"),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: priceFOcusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(descriptionfocusNode);
                },
                onSaved: (value) {
                  editedProduct = Product(
                      editedProduct.id,
                      editedProduct.title,
                      editedProduct.description,
                      double.parse(value ?? ""),
                      editedProduct.imageUrl,
                      editedProduct.isFavourite);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter price";
                  } else if (double.tryParse(value) == null) {
                    return "Please enter valid number";
                  } else if (double.parse(value) <= 0) {
                    return "Please enter number greater than 0";
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                initialValue: initValues["description"],
                decoration: const InputDecoration(
                  labelText: "Description",
                ),
                maxLines: 3,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                focusNode: descriptionfocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(imageFocusNode);
                },
                onSaved: (value) {
                  editedProduct = Product(editedProduct.id, editedProduct.title, value ?? "",
                      editedProduct.price, editedProduct.imageUrl, editedProduct.isFavourite);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter description";
                  } else if (value.length < 10) {
                    return "Please enter description more than 10 words";
                  } else {
                    return null;
                  }
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1), color: Colors.grey),
                      child: imageController.text.isEmpty
                          ? Text(
                              "enterUrl",
                            )
                          : FittedBox(
                              child: Image.network(imageController.text),
                              fit: BoxFit.cover,
                            )),
                  Expanded(
                    child: TextFormField(
                      // initialValue: initValues["imageUrl"],
                      decoration: InputDecoration(labelText: "upload image"),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: imageController,
                      focusNode: imageFocusNode,
                      onEditingComplete: () {
                        setState(() {});
                      },
                      onSaved: (value) {
                        editedProduct = Product(
                            editedProduct.id,
                            editedProduct.title,
                            editedProduct.description,
                            editedProduct.price,
                            value ?? "",
                            editedProduct.isFavourite);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter imageUrl";
                        } else if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return "Please enter valid url";
                        } else if (!value.endsWith('.jpg') &&
                            !value.endsWith('.png') &&
                            !value.endsWith('.jpeg')) {
                          return "Please enter valid url with valid extension";
                        } else {
                          return null;
                        }
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
