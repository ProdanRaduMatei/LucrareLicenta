import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Building {
  final int id;
  final String name;

  Building({required this.id, required this.name});

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      id: json['id'],
      name: json['name'],
    );
  }
}

class AddSeatLayout extends StatefulWidget {
  const AddSeatLayout({Key? key}) : super(key: key);

  @override
  State<AddSeatLayout> createState() => _AddSeatLayoutState();
}

class _AddSeatLayoutState extends State<AddSeatLayout> {
  final int maxRows = 25;
  final int maxCols = 25;
  late List<List<bool>> seatGrid;

  TextEditingController storeyNameController = TextEditingController();
  List<Building> buildings = [];
  Building? selectedBuilding;

  @override
  void initState() {
    super.initState();
    seatGrid = List.generate(maxRows, (_) => List.generate(maxCols, (_) => false));
    fetchBuildings();
  }

  void toggleSeat(int row, int col) {
    setState(() {
      seatGrid[row][col] = !seatGrid[row][col];
    });
  }

  Future<void> fetchBuildings() async {
    final dio = Dio();
    try {
      final response = await dio.get('http://127.0.0.1:8080/building/names');
      if (response.statusCode == 200 && response.data is List) {
        final List<Building> loaded = (response.data as List)
            .map((json) => Building.fromJson(json))
            .toList();
        setState(() {
          buildings = loaded;
          if (buildings.isNotEmpty) selectedBuilding = buildings.first;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch buildings: $e')),
      );
    }
  }

  Future<void> submitLayout() async {
    final storeyName = storeyNameController.text.trim();
    if (storeyName.isEmpty || selectedBuilding == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a storey name and select a building')),
      );
      return;
    }

    List<Map<String, dynamic>> seats = [];
    for (int i = 0; i < maxRows; i++) {
      for (int j = 0; j < maxCols; j++) {
        if (seatGrid[i][j]) {
          seats.add({'row': i, 'col': j});
        }
      }
    }

    final data = {
      'storeyName': storeyName,
      'buildingId': selectedBuilding!.id,
      'seats': seats,
    };

    final dio = Dio();
    try {
      final response = await dio.post(
        'http://127.0.0.1:8080/storey/layout',
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Storey layout created successfully')),
        );
        Navigator.pushReplacementNamed(context, '/adminBuildings');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create layout: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Seat Layout'),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: storeyNameController,
                decoration: InputDecoration(
                  labelText: 'Storey Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: DropdownButtonFormField<Building>(
                value: selectedBuilding,
                items: buildings.map((b) {
                  return DropdownMenuItem<Building>(
                    value: b,
                    child: Text(b.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBuilding = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Select Building',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(maxRows, (row) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(maxCols, (col) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: () => toggleSeat(row, col),
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: seatGrid[row][col] ? Colors.grey : Colors.white,
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: submitLayout,
                child: Text('Save Layout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}