import 'dart:ffi' as ffi;
import 'package:flutter/material.dart';
import 'package:service/model/todo_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../widgets/calculation_widget.dart';
import '../model/product_list.dart';

class P2 extends StatefulWidget {
  P2({super.key, required this.name, required this.id});
  
  final String name;
  final String id;
  final todoslist = ToDo.todos();

  @override
  _P2State createState() => _P2State();
}

class _P2State extends State<P2> {
  String productName = "Product Name"; // Default product name
  List<products> product_lists = products.product_list();
  products? updatedItem; // State variable to store the updated item

  @override
  void initState() {
    super.initState();
    _loadProductList();
    // _loadToDoList(); // Add this line to load the ToDo list
  }

  void _loadProductList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? productListString = prefs.getString('product_list_${widget.id}');
    if (productListString != null) {
      List<dynamic> productListJson = jsonDecode(productListString);
      setState(() {
        product_lists = productListJson.map((json) => products.fromJson(json)).toList();
      });
    } else {
      setState(() {
        product_lists = products.product_list();
      });
    }
  }

  void _saveProductList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String productListString = jsonEncode(product_lists.map((product) => product.toJson()).toList());
    prefs.setString('product_list_${widget.id}', productListString);
    print('Saved product list: $productListString');
  }

  void _addnewproduct(String productname) {
    setState(() {
      product_lists.add(products(todo_id: widget.id, id: DateTime.now().millisecondsSinceEpoch.toString(), product_name: productname));
      _saveProductList(); // Save the updated list
    });
  }

  void _handleDeletedItem(products item) {
    setState(() {
      product_lists.remove(item);
      _saveProductList(); // Save the updated list
    });
  }
  
  void _handleUpdatedItem(products item) {
    setState(() {
      int index = product_lists.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        product_lists[index] = item;
        updatedItem = item; // Update the state variable
        _saveProductList(); // Save the updated list
      }
      for (var i in product_lists) {
        if (i.id != item.id) {
          i.ischeck = false;
        }
      }
      // print(item.price);
    });
  }

  double getCheapestPricePerUnit() {
    double cheapestPricePerUnit = double.infinity;
    for (products item in product_lists) {
      if (item.todo_id == widget.id && item.price != null && item.amount != null && item.amount! > 0) {
        double pricePerUnit = ((item.price! / item.amount!));
        if (pricePerUnit < cheapestPricePerUnit) {
          cheapestPricePerUnit = pricePerUnit;
        }
      }
    }
    return cheapestPricePerUnit;
  }

  AppBar _buildappbar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          if (updatedItem == null || !updatedItem!.ischeck) {
            Navigator.pop(context, {
              'id': widget.id,
              'value': null,
              'isValue': false
            });
          } else {
            Navigator.pop(context, {
              'id': widget.id,
              'value': updatedItem?.price,
              'isValue': true
            });
          }
        },
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0), // Add padding to the left
                child: Text(
                  "Product List", // Use the name passed from the previous page
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network('https://avatars.githubusercontent.com/u/57899051?v=4'),
            ),
          )
        ],
      ),
    );
  }

  void _showTypeFirstDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("Type first"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showAddProductDialog() {
    TextEditingController productController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Product Name'),
          content: TextField(
            controller: productController,
            decoration: InputDecoration(hintText: "Product Name"),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (productController.text.isEmpty) {
                  _showTypeFirstDialog();
                } else {
                  setState(() {
                    _addnewproduct(productController.text);
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double cheapestPricePerUnit = getCheapestPricePerUnit();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      appBar: _buildappbar(),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                widget.name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8), // Add some space before the divider
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20), // Adjust the margin as needed
            child: Divider(
              color: Colors.grey, // Set the color of the divider
              thickness: 1, // Set the thickness of the divider
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                for (products item in product_lists)
                  if (item.todo_id == widget.id)
                    Dismissible(
                      key: Key(item.id!),
                      onDismissed: (direction) {
                        _handleDeletedItem(item);
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: CalculationWidget(
                        itemss: item,
                        ondeleteditem: _handleDeletedItem,
                        onUpdatedItem: _handleUpdatedItem,
                        isCheapest: item.price != null && item.amount != null && ((item.price! / item.amount!)) == cheapestPricePerUnit,
                      ),
                    ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: 20,
              right: 20,
            ),
            child: Column(
              children: [
                ElevatedButton(
                  child: Text('+', style: TextStyle(fontSize: 30, color: Colors.black)),
                  onPressed: _showAddProductDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 220, 82, 7),
                    minimumSize: const Size(50, 50),
                    elevation: 10,
                  ),
                ),
                Text(
                  "Add Item",
                  style: TextStyle(color: Colors.grey, fontSize: 18), // Increased font size
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}