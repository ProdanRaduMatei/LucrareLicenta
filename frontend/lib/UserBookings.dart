import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'SeatBookingScreen.dart';

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
            "date": item["date"],
            "bookingId": item["bookingId"],
          }).toList();

          // Sort by date ascending
          bookings.sort((a, b) => DateTime.parse(a["date"])
              .compareTo(DateTime.parse(b["date"])));

          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching bookings: $e");
    }
  }

  Future<void> deleteBooking(int bookingId) async {
    try {
      final response = await http.delete(
        Uri.parse("http://127.0.0.1:8080/booking/delete"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"bookingId": bookingId}),
      );

      if (response.statusCode == 200) {
        setState(() {
          bookings.removeWhere((b) => b["bookingId"] == bookingId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete booking')),
        );
      }
    } catch (e) {
      print("Error deleting booking: $e");
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
            title: Center(
              child: Text(
                "Booking Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 12),
                Text(
                  "Seat ID: $seatId",
                  style: TextStyle(fontSize: 16, letterSpacing: 1.0),
                ),
                SizedBox(height: 16),
                Text.rich(
                  TextSpan(
                    text: "Row: ",
                    style: TextStyle(fontSize: 16, letterSpacing: 1.0),
                    children: [
                      TextSpan(
                          text: "${lineCol[0]}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text.rich(
                  TextSpan(
                    text: "Column: ",
                    style: TextStyle(fontSize: 16, letterSpacing: 1.0),
                    children: [
                      TextSpan(
                          text: "${lineCol[1]}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text.rich(
                  TextSpan(
                    text: "Storey: ",
                    style: TextStyle(fontSize: 16, letterSpacing: 1.0),
                    children: [
                      TextSpan(
                          text: "$storey",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
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
      }
    } catch (e) {
      print("Error fetching seat details: $e");
    }
  }

  Widget buildBookingCard(Map<String, dynamic> booking, {bool showDelete = true}) {
    final formattedDate =
    DateFormat('dd MMM yyyy').format(DateTime.parse(booking["date"]));

    return GestureDetector(
      onTap: () => fetchDetailsForSeat(booking["seatId"]),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.event_seat, size: 30, color: Colors.deepPurple),
                    SizedBox(height: 10),
                    Text.rich(
                      TextSpan(
                        text: "Seat ID: ",
                        style: TextStyle(fontSize: 16),
                        children: [
                          TextSpan(
                            text: "${booking['seatId']}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text.rich(
                      TextSpan(
                        text: "Booking Date: ",
                        style: TextStyle(fontSize: 18),
                        children: [
                          TextSpan(
                            text: formattedDate,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            if (showDelete)
              Positioned(
                bottom: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.grey),
                  onPressed: () => deleteBooking(booking["bookingId"]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayDateOnly = DateTime(today.year, today.month, today.day);

    final upcoming = bookings.where((b) {
      final bookingDate = DateTime.parse(b['date']);
      final bookingDateOnly =
      DateTime(bookingDate.year, bookingDate.month, bookingDate.day);
      return bookingDateOnly.isAtSameMomentAs(todayDateOnly) ||
          bookingDateOnly.isAfter(todayDateOnly);
    }).toList();

    final past = bookings.where((b) {
      final bookingDate = DateTime.parse(b['date']);
      final bookingDateOnly =
      DateTime(bookingDate.year, bookingDate.month, bookingDate.day);
      return bookingDateOnly.isBefore(todayDateOnly);
    }).toList();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color(0xFFB1B2B5),
        appBar: AppBar(
          title: Text(
            "Your Bookings",
            style: TextStyle(color: Colors.white),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFF4A477F),
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: IconButton(
                icon: Icon(Icons.add),
                tooltip: 'New Booking',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SeatBookingScreen()),
                  );
                },
              ),
            ),
          ],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : bookings.isEmpty
            ? Center(child: Text("No bookings found."))
            : ListView(
          children: [
            if (upcoming.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8), // extra top space
                child: Center(
                  child: Text(
                    "Upcoming Bookings",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ...upcoming.map((b) => buildBookingCard(b, showDelete: true)),

            if (past.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8), // extra top space
                child: Center(
                  child: Text(
                    "Past Bookings",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ...past.map((b) => buildBookingCard(b, showDelete: false)),
          ],
        ),
      ),
    );
  }
}