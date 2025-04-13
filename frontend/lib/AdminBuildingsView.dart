import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class BuildingStorey {
  final String buildingName;
  final List<String> storeys;

  BuildingStorey({required this.buildingName, required this.storeys});

  factory BuildingStorey.fromJson(Map<String, dynamic> json) {
    return BuildingStorey(
      buildingName: json['buildingName'],
      storeys: List<String>.from(json['storeys']),
    );
  }
}

class AdminBuildingsView extends StatefulWidget {
  @override
  _AdminBuildingsViewState createState() => _AdminBuildingsViewState();
}

class _AdminBuildingsViewState extends State<AdminBuildingsView> {
  List<BuildingStorey> buildings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBuildingsWithStoreys();
  }

  Future<void> fetchBuildingsWithStoreys() async {
    try {
      final response = await http.get(Uri.parse("http://127.0.0.1:8080/building/storeys"));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          buildings = data.map((e) => BuildingStorey.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        print("Failed to fetch buildings: ${response.body}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() => isLoading = false);
    }
  }

  Widget buildCard(BuildingStorey building) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        title: Text(
          building.buildingName,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        children: building.storeys.map((storey) {
          return ListTile(
            title: Text("• $storey"),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB1B2B5),
      appBar: AppBar(
        title: Text("Buildings and Storeys", style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF4A477F),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              tooltip: 'Add Seat Layout',
              onPressed: () {
                Navigator.pushNamed(context, '/addSeatLayout');
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : buildings.isEmpty
          ? Center(child: Text("No buildings found."))
          : ListView(children: buildings.map(buildCard).toList()),
    );
  }
}