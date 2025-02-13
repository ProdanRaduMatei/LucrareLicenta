import 'package:flutter/material.dart';
import 'Login.dart';
import 'Register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(primarySwatch: Colors.purple),
      initialRoute: '/login',
      routes: {
        '/register': (context) => Register(),
        '/login': (context) => Login(),
      },
    );
  }
}