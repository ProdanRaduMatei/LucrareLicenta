import 'package:flutter/material.dart';
import 'SeatBookingScreen.dart';
import 'SeatSurferTextWidget.dart';
import 'authentication/AdminRegister.dart';
import 'package:frontend/authentication/AdminLogin.dart';
import 'authentication/UserRegister.dart';
import 'authentication/UserLogin.dart';
import 'Dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(primarySwatch: Colors.purple),
      initialRoute: '/',
      routes: {
        '/': (context) => SeatSurferTextWidget(),
        '/adminRegister': (context) => AdminRegister(),
        '/userRegister': (context) => UserRegister(),
        '/adminLogin': (context) => AdminLogin(),
        "/userLogin": (context) => UserLogin(),
        "/dashboard": (context) => Dashboard(),
        "/seatBookingScreen": (context) => SeatBookingScreen(),
      },
    );
  }
}