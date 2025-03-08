import 'dart:ffi' as ffi;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/carousel_slider_img.dart';

import '../screens/calculation.dart';
import '../widgets/todo.dart';
import '../model/todo_item.dart';
import '../model/product_list_provider.dart';
import 'shopping_cart.dart';

class Home extends StatefulWidget {
  Home({super.key, this.id_item, this.value_item, this.isValue_item});
  final String? id_item;
  final double? value_item;
  final bool? isValue_item;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ToDo> todoslist = [];
  final TextEditingController _todocontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadToDoList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateToDoItem();
  }

  void _loadToDoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? todosString = prefs.getString('todos');
    if (todosString != null) {
      List<dynamic> todosJson = jsonDecode(todosString);
      setState(() {
        todoslist = todosJson.map((jsonString) => ToDo.fromJson(jsonDecode(jsonString))).toList();
        print('Loaded todos list: $todoslist');
      });
    } else {
      todoslist = ToDo.todos();
      print('Default todos list: $todoslist');
    }
  }

  void _saveToDoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> todosJson = todoslist.map((todo) => jsonEncode(todo.toJson())).toList();
    prefs.setString('todos', jsonEncode(todosJson));
    print('Saved todos list: $todosJson');
    print('id ${widget.id_item} value ${widget.value_item} isValue ${widget.isValue_item}');
  }

  void _handletodochage(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
    _saveToDoList();
  }

  void _handleDeletedItem(ToDo todo) {
    setState(() {
      todoslist.remove(todo);
    });
    _saveToDoList();
  }

  void _addtodoitem(String todoText) {
    setState(() {
      todoslist.add(ToDo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        todoText: todoText,
      ));
    });
    _todocontroller.clear();
    _saveToDoList();
  }

  void _updateToDoItem() {
    print('updateToDoItem called with id: ${widget.id_item}, value: ${widget.value_item}, isValue: ${widget.isValue_item}');
    if (widget.id_item != null) {
      print('Updating todo item');
      setState(() {
        for (var todo in todoslist) {
          if (todo.id == widget.id_item) {
            todo.value = widget.value_item;
            todo.isValue = widget.isValue_item ?? false;
            break;
          }
        }
      });
      print('Updated!');
      _saveToDoList();
    }
  }

  bool _isAnyToDoDone() {
    return todoslist.any((todo) => todo.isDone);
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

  AppBar _buildappbar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.menu,
            color: const Color.fromARGB(255, 0, 0, 0),
            size: 30
          ),
          Container(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network('https://avatars.githubusercontent.com/u/57899051?v=4'),
            ),
          )
        ],),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 234, 234, 234),
      appBar: _buildappbar(),
      body: Column(
        children: [
          carosel_sliding(),
          SizedBox(height: 20),
          Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Shopping list',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 10), // Add some space between the text and the list
        Expanded(
            child: ListView(
              children: [
                for (var todoo in todoslist)
                  Dismissible(
                    key: Key(todoo.id!),
                    onDismissed: (direction) {
                      _handleDeletedItem(todoo);
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
                    
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
                      child: TodoItem(
                        todo: todoo,
                        ontodochanged: (updatedTodo) {
                          setState(() {
                            int index = todoslist.indexWhere((t) => t.id == updatedTodo.id);
                            if (index != -1) {
                              todoslist[index] = updatedTodo;
                            }
                          });
                          _saveToDoList();
                        },
                        ondeleteditem: _handleDeletedItem,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              if (_isAnyToDoDone())
                Container(
                margin: EdgeInsets.only(
                  bottom: 20,
                  left: 20,
                  ),
                child: ElevatedButton(
                  child: Icon(
                    Icons.shopping_cart,
                    color: Colors.black,),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShoppingCart(),
                      ),
                    );
                    _loadToDoList(); // Reload the list when coming back from the shopping cart page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 220, 82, 7),
                    minimumSize: const Size(50, 50),
                    elevation: 0,
                    shadowColor: Colors.transparent
                  ),
                )
              ),
              Expanded(child: Container(
                margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5,
                      spreadRadius: 0,
                      offset: Offset(0, 0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: _todocontroller,
                  decoration: InputDecoration(
                    hintText: 'Add a new item',
                    hintStyle: GoogleFonts.roboto(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    border: InputBorder.none,
                  ),
                ),
              )),
              Container(
              margin: EdgeInsets.only(
                bottom: 20,
                right: 20,
                ),
              child: ElevatedButton(
                child: Text('+', style: TextStyle(fontSize: 30, color: Colors.black),),
                onPressed: (){
                  if (_todocontroller.text.isEmpty) {
                    _showTypeFirstDialog();
                  } else {
                    _addtodoitem(_todocontroller.text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 220, 82, 7),
                  minimumSize: const Size(50, 50),
                  elevation: 0,
                  shadowColor: Colors.transparent
              ),
            )
            ),
            ],
            ),
          )
        ]
      ),
    );
  }
}