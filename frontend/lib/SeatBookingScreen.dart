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
  List<String> storeyNames = []; // ✅ Storey names list
  String apiUrl = "http://127.0.0.1:8080/seats/layout";
  String storeyUrl = "http://127.0.0.1:8080/storey/all"; // ✅ API for floor names
  String selectedStorey = ""; // ✅ Default storey (set after fetch)
  String selectedDate = DateFormat("yyyy-MM-dd'T'00:00:00'Z'").format(DateTime.now()); // ✅ Default date
  Set<String> selectedSeats = {};

  @override
  void initState() {
    super.initState();
    fetchStoreyNames(); // ✅ Fetch floor names first
  }

  // ✅ Fetch all storey names
  Future<void> fetchStoreyNames() async {
    try {
      var response = await http.get(Uri.parse(storeyUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          storeyNames = List<String>.from(data);
          if (storeyNames.isNotEmpty) {
            selectedStorey = storeyNames[0]; // Set default selected storey
            fetchSeatLayout(); // ✅ Fetch seat layout after setting storey
          }
        });
      } else {
        print("Failed to load storey names: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching storey names: $e");
    }
  }

  // ✅ Fetch seat layout (POST method with body)
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

  // ✅ Toggle seat selection
  void toggleSeatSelection(int row, int col) {
    String seatKey = "$row-$col";
    if (selectedSeats.contains(seatKey)) {
      selectedSeats.remove(seatKey);
    } else {
      selectedSeats.add(seatKey);
    }
    setState(() {});
  }

  // ✅ Select date
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
        fetchSeatLayout(); // ✅ Refresh data after selecting date
      });
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
      body: Column(
        children: [
          // **Dropdown & Date Picker Section**
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // ✅ Storey Selection Dropdown
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
                          fetchSeatLayout(); // ✅ Refresh data
                        });
                      },
                    ),
                  ],
                ),

                // ✅ Date Picker
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

          // **Seat Layout**
          Expanded(
            child: seatLayout.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(seatLayout.length, (row) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(seatLayout[row].length, (col) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: seatLayout[row][col] == 0
                              ? SizedBox(width: 20, height: 20) // Empty space
                              : GestureDetector(
                            onTap: seatLayout[row][col] == 1
                                ? () => toggleSeatSelection(row, col)
                                : null,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: seatLayout[row][col] == 2
                                    ? Colors.red // 🔴 Booked Seat
                                    : selectedSeats.contains("$row-$col")
                                    ? Colors.white // ⚪ Selected Seat
                                    : Colors.grey, // ⚫ Empty Seat
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
            ),
          ),
        ],
      ),
    );
  }
}