import 'package:flutter/material.dart';
import 'product_list.dart';
import 'todo_item.dart';

class ProductListProvider with ChangeNotifier {
  List<products> _productLists = [];

  List<products> get productLists => _productLists;

  void addProduct(products product) {
    _productLists.add(product);
    notifyListeners();
  }

  void removeProduct(String id) {
    _productLists.removeWhere((product) => product.id == id);
    notifyListeners();
  }

  void updateProductPrice(String id, double price) {
    final product = _productLists.firstWhere((product) => product.id == id);
    product.price = price;
    notifyListeners();
  }
}