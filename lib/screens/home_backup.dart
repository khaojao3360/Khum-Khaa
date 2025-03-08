import 'dart:ffi' as ffi;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../widgets/carousel_slider_img.dart';

import '../screens/calculation.dart';
import '../widgets/todo.dart';
import '../model/todo_item.dart';
import '../model/product_list_provider.dart';


class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todoslist = ToDo.todos();
  final TextEditingController _todocontroller = TextEditingController();

  void _handletodochage(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }
  void _handleDeletedItem(ToDo todo) {
    setState(() {
      todoslist.remove(todo);
    });
  }
  void _addtodoitem(String todoText) {
    setState(() {
      todoslist.add(ToDo(id: DateTime.now().millisecondsSinceEpoch.toString(), todoText: todoText));
    });
    _todocontroller.clear();
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
                        ontodochanged: _handletodochage,
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
                  _addtodoitem(_todocontroller.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 220, 82, 7),
                  minimumSize: const Size(50, 50),
                  elevation: 10,
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
