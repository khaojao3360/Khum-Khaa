import 'package:flutter/material.dart';
import '../model/todo_item.dart';

class ShoppingCartWidget extends StatefulWidget {
  final ToDo todo;
  final Function(ToDo, int) onQuantityChanged;

  ShoppingCartWidget({super.key, required this.todo, required this.onQuantityChanged});

  @override
  _ShoppingCartWidgetState createState() => _ShoppingCartWidgetState();
}

class _ShoppingCartWidgetState extends State<ShoppingCartWidget> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    double totalPrice = (widget.todo.value ?? 0) * quantity;

    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      tileColor: Colors.white,
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.todo.todoText ?? 'No title', // Handle null value
                style: const TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${totalPrice.toStringAsFixed(2)} THB", // Handle null value
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (quantity > 1) quantity--;
                    widget.onQuantityChanged(widget.todo, quantity);
                  });
                },
              ),
              Text('$quantity'),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    quantity++;
                    widget.onQuantityChanged(widget.todo, quantity);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}