import 'package:flutter/material.dart';
import '../model/todo_item.dart';
import '../widgets/shopping_cart_widget.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ShoppingCart extends StatefulWidget {
  ShoppingCart({Key? key}) : super(key: key);

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  List<ToDo> todoslist = [];
  final TextEditingController _todocontroller = TextEditingController();
  Map<ToDo, int> quantities = {};

  @override
  void initState() {
    super.initState();
    _loadToDoList();
  }

  void _loadToDoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? todosString = prefs.getString('todos');
    if (todosString != null) {
      List<dynamic> todosJson = jsonDecode(todosString);
      setState(() {
        todoslist = todosJson.map((jsonString) => ToDo.fromJson(jsonDecode(jsonString))).toList();
        quantities = {for (var todo in todoslist) todo: 1};
        print('Loaded todos list: $todoslist');
      });
    } else {
      todoslist = ToDo.todos();
      quantities = {for (var todo in todoslist) todo: 1};
      print('Default todos list: $todoslist');
    }
  }

  void _saveToDoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> todosJson = todoslist.map((todo) => jsonEncode(todo.toJson())).toList();
    prefs.setString('todos', jsonEncode(todosJson));
  }

  double _calculateTotalPrice() {
    return todoslist
        .where((todo) => todo.isDone)
        .fold(0, (sum, todo) => sum + (todo.value ?? 0) * (quantities[todo] ?? 1));
  }

  void _onQuantityChanged(ToDo todo, int quantity) {
    setState(() {
      quantities[todo] = quantity;
    });
  }

  void _handlePurchase() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Purchased"),
          content: Text("Your items have been purchased."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  todoslist.removeWhere((todo) => todo.isDone);
                  _saveToDoList();
                });
                Navigator.of(context).pop(); // Navigate back to home page
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = _calculateTotalPrice();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      appBar: _buildappbar(),
      body: Column(
        children: [
          Container(
            child: const Text(
              "Make a purchase",
              textAlign: TextAlign.center,
            ),
          ),
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
                for (var todoo in todoslist)
                  if (todoo.isDone)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
                      child: ShoppingCartWidget(
                        todo: todoo,
                        onQuantityChanged: _onQuantityChanged,
                      ),
                    ),
              ],
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 220, 82, 7),
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "${totalPrice.toStringAsFixed(2)} THB",
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10), // Add some space between the rows
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: _handlePurchase,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Increase the border radius for roundness
                        ),
                        minimumSize: Size(100, 30), // Set the minimum size of the button
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.shopping_cart,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                          Text(
                            "CHECK OUT",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildappbar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
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
                  "Shopping Cart", // Use the name passed from the previous page
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
          ),
        ],
      ),
    );
  }
}