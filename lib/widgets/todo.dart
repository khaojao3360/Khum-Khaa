import 'package:flutter/material.dart';
import 'package:service/screens/calculation.dart';
import '../model/todo_item.dart';

class TodoItem extends StatelessWidget {
  final ToDo todo;
  final Function(ToDo) ontodochanged;
  final Function(ToDo) ondeleteditem;

  const TodoItem({
    Key? key,
    required this.todo,
    required this.ontodochanged,
    required this.ondeleteditem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (todo.isValue) {
          ontodochanged(todo.copyWith(isDone: !todo.isDone));
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Incomplete Item'),
                content: Text('You need to fill the price first.'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      tileColor: todo.isValue ? const Color.fromARGB(255, 220, 82, 7) : Colors.white,
      leading: Icon(
        todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
        color: todo.isValue ? Colors.white : const Color.fromARGB(255, 220, 82, 7),
      ),
      title: Text(
        todo.todoText!,
        style: TextStyle(
          fontSize: 20,
          color: todo.isDone ? const Color.fromARGB(255, 0, 0, 0) : Colors.black,
          decoration: todo.isDone ? TextDecoration.lineThrough : null,
          fontWeight: todo.isDone ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: Container(
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.symmetric(vertical: 12),
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: todo.isValue ? Colors.white : const Color.fromARGB(255, 220, 82, 7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: IconButton(
          color: Colors.white,
          icon: Icon(
            Icons.arrow_forward_ios_outlined,
            color: todo.isValue ? const Color.fromARGB(255, 220, 82, 7) : Colors.white,
            size: 18,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => P2(
                  name: todo.todoText!,
                  id: todo.id!,
                ),
              ),
            ).then((result) {
              if (result != null) {
                // Update the todo item with the returned data
                ontodochanged(todo.copyWith(
                  value: result['value'],
                  isValue: result['isValue'],
                ));
              }
            });
          },
        ),
      ),
    );
  }
}