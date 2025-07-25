import 'package:flutter/material.dart';
import 'SeatBookingScreen.dart';
import 'SeatSurferTextWidget.dart';
import 'authentication/AdminRegister.dart';
import 'package:frontend/authentication/AdminLogin.dart';
import 'authentication/UserRegister.dart';
import 'authentication/UserLogin.dart';
import 'UserBookings.dart';
import 'Dashboard.dart';
import 'AddSeatLayout.dart';
import 'AdminBuildingsView.dart';
import 'AdminOccupancyReport.dart';

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
        "/userBookings": (context) => UserBookings(),
        "/addSeatLayout": (context) => AddSeatLayout(),
        "/adminBuildings": (context) => AdminBuildingsView(),
        "/adminOccupancyReport": (context) => AdminOccupancyReport(storeyName: ""),
      },
    );
  }
}