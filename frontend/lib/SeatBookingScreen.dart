import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class SeatBookingScreen extends StatefulWidget {
  @override
  _SeatBookingScreenState createState() => _SeatBookingScreenState();
}

class _SeatBookingScreenState extends State<SeatBookingScreen> {
  List<List<int>> seatLayout = [];
  List<String> storeyNames = [];
  String apiUrl = "http://127.0.0.1:8080/seats/layout";
  String storeyUrl = "http://127.0.0.1:8080/storey/all";
  String bookingUrl = "http://127.0.0.1:8080/booking/book";

  String selectedStorey = "";
  String selectedDate = DateFormat("yyyy-MM-dd'T'00:00:00'Z'").format(DateTime.now());
  Set<String> selectedSeats = {};
  String userEmail = "user@example.com";

  @override
  void initState() {
    super.initState();
    fetchStoreyNames();
  }

  Future<void> fetchStoreyNames() async {
    try {
      var response = await http.get(Uri.parse(storeyUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          storeyNames = List<String>.from(data);
          if (storeyNames.isNotEmpty) {
            selectedStorey = storeyNames[0];
            fetchSeatLayout();
          }
        });
      } else {
        print("Failed to load storey names: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching storey names: $e");
    }
  }

  Future<void> fetchSeatLayout() async {
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'date': selectedDate,
          'storeyName': selectedStorey,
        }),
      );

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          seatLayout = data.map<List<int>>((row) => List<int>.from(row)).toList();
        });
      } else {
        print("Failed to load seat layout: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching seat layout: $e");
    }
  }

  void toggleSeatSelection(int row, int col) {
    String seatKey = "$row-$col";
    if (selectedSeats.contains(seatKey)) {
      selectedSeats.remove(seatKey);
    } else {
      selectedSeats.add(seatKey);
    }
    setState(() {});
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime today = DateTime.now();
    DateTime lastDay = today.add(Duration(days: 7));

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: lastDay,
    );

    if (picked != null) {
      setState(() {
        selectedDate = DateFormat("yyyy-MM-dd'T'00:00:00'Z'").format(picked);
        fetchSeatLayout();
      });
    }
  }

  Future<void> bookSeats() async {
    if (selectedSeats.isEmpty) {
      print("No seats selected");
      return;
    }

    List<Map<String, int>> selectedSeatList = selectedSeats.map((seat) {
      List<String> parts = seat.split("-");
      return {
        "row": int.parse(parts[0]),
        "col": int.parse(parts[1]),
      };
    }).toList();

    Map<String, dynamic> bookingData = {
      "date": selectedDate,
      "storeyName": selectedStorey,
      "userEmail": userEmail,
      "selectedSeats": selectedSeatList,
    };

    try {
      var response = await http.post(
        Uri.parse(bookingUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(bookingData),
      );

      print("Booking Response Code: ${response.statusCode}");
      print("Booking Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Booking successful");
        fetchSeatLayout();
      } else {
        print("Booking failed: ${response.statusCode}");
      }
    } catch (e) {
      print("Error booking seats: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "SEAT SURFER",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A477F),
          ),
        ),
      ),
      body: SingleChildScrollView( // ✅ Wrap Column with SingleChildScrollView
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Storey Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      storeyNames.isEmpty
                          ? CircularProgressIndicator()
                          : DropdownButton<String>(
                        value: selectedStorey,
                        items: storeyNames.map((storey) {
                          return DropdownMenuItem<String>(
                            value: storey,
                            child: Text(storey),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedStorey = value!;
                            fetchSeatLayout();
                          });
                        },
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Date", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ElevatedButton(
                        onPressed: () => selectDate(context),
                        child: Text(selectedDate),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal, // ✅ Allow horizontal scrolling
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(seatLayout.length, (row) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(seatLayout[row].length, (col) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: seatLayout[row][col] == 0
                            ? SizedBox(width: 20, height: 20)
                            : GestureDetector(
                          onTap: seatLayout[row][col] == 1 ? () => toggleSeatSelection(row, col) : null,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: seatLayout[row][col] == 2
                                  ? Colors.red
                                  : selectedSeats.contains("$row-$col")
                                  ? Colors.white
                                  : Colors.grey,
                              border: Border.all(color: Colors.black),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton( // ✅ Added padding around button
                onPressed: bookSeats,
                child: Text("Confirm Booking"),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}