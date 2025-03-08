import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class products {
  String? todo_id;
  String? id;
  String? product_name;
  bool ischeck;
  double? price;
  int? amount;

  products({
    required this.todo_id,
    this.id,
    this.product_name,
    this.ischeck = false,
    this.price,
    this.amount,
  });

  static List<products> product_list() {
    return [
    ];
  }// Default product name

  factory products.fromJson(Map<String, dynamic> json) {
    return products(
      todo_id: json['todo_id'],
      id: json['id'],
      product_name: json['product_name'],
      ischeck: json['ischeck'],
      price: json['price'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'todo_id': todo_id,
      'id': id,
      'product_name': product_name,
      'ischeck': ischeck,
      'price': price,
      'amount': amount,
    };
  }
}