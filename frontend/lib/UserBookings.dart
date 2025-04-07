import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart'; // 📦 Added for date formatting

class UserBookings extends StatefulWidget {
  @override
  _UserBookingsState createState() => _UserBookingsState();
}

class _UserBookingsState extends State<UserBookings> {
  List<Map<String, dynamic>> bookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadEmailAndFetchBookings();
  }

  Future<void> loadEmailAndFetchBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail');

    if (email == null) {
      print("⚠️ No email found in SharedPreferences");
      return;
    }

    print("✅ Loaded user email from prefs: $email");
    await fetchBookings(email);
  }

  Future<void> fetchBookings(String email) async {
    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:8080/booking/bookings"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"userEmail": email}),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          bookings = data.map<Map<String, dynamic>>((item) => {
            "seatId": item["seatId"],
            "date": item["date"]
          }).toList();
          isLoading = false;
        });
      } else {
        print("Failed to fetch bookings. Code: ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching bookings: $e");
    }
  }

  Future<void> fetchDetailsForSeat(int seatId) async {
    try {
      final lineColRes = await http.post(
        Uri.parse("http://127.0.0.1:8080/seats/seat"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"seatId": seatId}),
      );

      final storeyRes = await http.post(
        Uri.parse("http://127.0.0.1:8080/storey/name"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"seatId": seatId}),
      );

      if (lineColRes.statusCode == 200 && storeyRes.statusCode == 200) {
        List<dynamic> lineCol = jsonDecode(lineColRes.body);
        String storey = storeyRes.body;

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Booking Details"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Seat ID: $seatId"),
                Text("Row: ${lineCol[0]}"),
                Text("Column: ${lineCol[1]}"),
                Text("Storey: $storey"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Close"),
              ),
            ],
          ),
        );
      } else {
        print("Failed to get seat details.");
      }
    } catch (e) {
      print("Error fetching seat details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Bookings"),
        backgroundColor: Color(0xFF4A477F),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : bookings.isEmpty
          ? Center(child: Text("No bookings found."))
          : ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];

          // 🎯 Format the date to "dd MMM yyyy"
          String formattedDate = "";
          try {
            formattedDate = DateFormat('dd MMM yyyy')
                .format(DateTime.parse(booking['date']));
          } catch (e) {
            formattedDate = booking['date'];
          }

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            margin:
            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Center(
                child: Column(
                  children: [
                    Icon(Icons.event_seat,
                        size: 30, color: Colors.deepPurple),
                    SizedBox(height: 10),
                    Text("Seat ID: ${booking['seatId']}",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text("Booking Date: $formattedDate",
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              onTap: () =>
                  fetchDetailsForSeat(booking['seatId']),
            ),
          );
        },
      ),
    );
  }
}