import 'package:flutter/material.dart';
import 'SignInPage.dart';
import 'SignUpPage.dart';

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
      initialRoute: '/signin',
      routes: {
        '/signin': (context) => SignInPage(),
        '/signup': (context) => SignUpPage(),
      },
    );
  }
}