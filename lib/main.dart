import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/product_list_provider.dart';
import 'package:provider/provider.dart';
import 'package:service/screens/home.dart';
import 'package:service/screens/calculation.dart';

void main() {
  runApp(MyApp(),);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light
      )
    );
    return MaterialApp(
      title: 'To Do EiEi',
      home: Home(),
    );
  }
}