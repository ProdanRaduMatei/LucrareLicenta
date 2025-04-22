import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class AdminOccupancyReport extends StatefulWidget {
  final String storeyName;
  const AdminOccupancyReport({required this.storeyName});

  @override
  State<AdminOccupancyReport> createState() => _AdminOccupancyReportState();
}

class _AdminOccupancyReportState extends State<AdminOccupancyReport> {
  DateTime? startDate;
  DateTime? endDate;
  Map<String, dynamic>? stats;
  bool isLoading = false;

  Future<void> selectDates() async {
    final pickedStart = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 7)),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (pickedStart != null) {
      final pickedEnd = await showDatePicker(
        context: context,
        initialDate: pickedStart.add(Duration(days: 1)),
        firstDate: pickedStart,
        lastDate: DateTime(2030),
      );

      if (pickedEnd != null) {
        setState(() {
          startDate = pickedStart;
          endDate = pickedEnd;
        });

        await fetchStats();
      }
    }
  }

  Future<void> fetchStats() async {
    if (startDate == null || endDate == null) return;
    setState(() => isLoading = true);

    final response = await http.post(
      Uri.parse("http://127.0.0.1:8080/storey/occupancy"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "storeyName": widget.storeyName,
        "startDate": DateFormat("yyyy-MM-dd").format(startDate!),
        "endDate": DateFormat("yyyy-MM-dd").format(endDate!),
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        stats = json.decode(response.body);
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Occupancy for ${widget.storeyName}"),
        backgroundColor: Color(0xFF4A477F),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: selectDates,
                child: Text("Select Date Range", style: TextStyle(fontSize: 18)),
              ),
              if (startDate != null && endDate != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "From ${DateFormat.yMMMd().format(startDate!)} to ${DateFormat.yMMMd().format(endDate!)}",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (isLoading)
                CircularProgressIndicator()
              else if (stats != null)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text("Total Seats: ${stats!['totalSeats']}", style: TextStyle(fontSize: 18)),
                        SizedBox(height: 8),
                        Text("Booked Seats: ${stats!['bookedSeats']}", style: TextStyle(fontSize: 18)),
                        SizedBox(height: 8),
                        Text("Unbooked Seats: ${stats!['unbookedSeats']}", style: TextStyle(fontSize: 18)),
                        SizedBox(height: 8),
                        Text("Occupancy: ${stats!['occupancyPercent'].toStringAsFixed(2)}%", style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}