import 'dart:ffi';
import 'product_list.dart';
import 'dart:convert';
import 'package:service/model/product_list.dart';

class ToDo {
  String? id;
  String? todoText;
  bool isDone;
  bool isValue;
  double? value;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
    this.isValue = false,
    this.value,
  });

  static List<ToDo> todos() {
    return [
      ToDo(id: '03', todoText: 'Carrot', isDone: false),
      ToDo(id: '04', todoText: 'Milk', isDone: false),
    ];
  }

  factory ToDo.fromJson(Map<String, dynamic> json) {
    return ToDo(
      id: json['id'],
      todoText: json['todoText'],
      isDone: json['isDone'],
      isValue: json['isValue'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todoText': todoText,
      'isDone': isDone,
      'isValue': isValue,
      'value': value,
    };
  }
  ToDo copyWith({String? id, String? todoText, bool? isDone, double? value, bool? isValue}) {
    return ToDo(
      id: id ?? this.id,
      todoText: todoText ?? this.todoText,
      isDone: isDone ?? this.isDone,
      value: value ?? this.value,
      isValue: isValue ?? this.isValue,
    );
  }
}