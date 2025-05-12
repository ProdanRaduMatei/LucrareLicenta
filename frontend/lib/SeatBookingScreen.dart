import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'UserBookings.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<String> suggestedSeats = [];

  @override
  void initState() {
    super.initState();
    loadUserEmail();
    fetchStoreyNames();
  }

  Future<void> loadUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('userEmail') ?? "guest@example.com";
    });
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

  int getTotalSeats() {
    int total = 0;
    for (var row in seatLayout) {
      for (var seat in row) {
        if (seat != 0) total++;
      }
    }
    return total;
  }

  int getOccupiedSeats() {
    int occupied = 0;
    for (var row in seatLayout) {
      for (var seat in row) {
        if (seat == 2) occupied++;
      }
    }
    return occupied;
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchSeatLayout();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserBookings()),
        );
      } else {
        print("Booking failed: ${response.statusCode}");
      }
    } catch (e) {
      print("Error booking seats: $e");
    }
  }

  Future<void> fetchSeatSuggestions() async {
    final payload = {
      "userEmail": userEmail,
      "storeyName": selectedStorey,
      "date": selectedDate
    };

    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:8080/ai/suggest-seats"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List suggestions = data['suggestions'];
        setState(() {
          // Only take top 3 suggestions, store with rank
          suggestedSeats = suggestions.take(3).map<String>((s) => "${s['row']}-${s['col']}").toList();
        });
        if (suggestedSeats.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No suggestions available.")));
        }
      } else {
        print("Suggestion fetch failed: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching suggestions: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
            "SEAT SURFER",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A477F),
            ),
          ),
        ),
        body: SingleChildScrollView(
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
              if (seatLayout.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Occupied: ${getOccupiedSeats()} / ${getTotalSeats()}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              SingleChildScrollView(
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
                              ? SizedBox(width: 20, height: 20)
                              : GestureDetector(
                                  onTap: seatLayout[row][col] == 1 ? () => toggleSeatSelection(row, col) : null,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      // Gradient coloring for top 3 suggestions
                                      color: (() {
                                        Color seatColor;
                                        String key = "$row-$col";
                                        if (seatLayout[row][col] == 2) {
                                          seatColor = Colors.red;
                                        } else if (selectedSeats.contains(key)) {
                                          seatColor = Colors.white;
                                        } else if (suggestedSeats.contains(key)) {
                                          int index = suggestedSeats.indexOf(key);
                                          if (index == 0) {
                                            seatColor = Color(0xFF6555B9); // New lighter purple for best
                                          } else if (index == 1) {
                                            seatColor = Color(0xFF8E79D1); // New medium-light purple
                                          } else {
                                            seatColor = Color(0xFFB8A6E5); // New lightest purple
                                          }
                                        } else {
                                          seatColor = Colors.grey;
                                        }
                                        return seatColor;
                                      })(),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: ElevatedButton(
                  onPressed: bookSeats,
                  child: Text("Confirm Booking"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    textStyle: TextStyle(fontSize: 18),
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: ElevatedButton(
                  onPressed: fetchSeatSuggestions,
                  child: Text(
                    "Suggest a Seat",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    textStyle: TextStyle(fontSize: 18),
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.deepPurple,
                  ).copyWith(
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) return Color(0xFFD1C6F4);
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
