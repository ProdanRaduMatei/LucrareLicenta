import 'package:flutter/material.dart';

class SeatSurferTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background Rectangle (Covers Entire Screen)
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
              color: Color(0xFFB1B2B5), // Gray background color from CSS
            ),
          ),

          // Centered Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SEAT SURFER Text
                Text(
                  "SEAT SURFER",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Exo2",
                    color: Color(0xFF4A477F), // Matching the dark blue color
                    shadows: [
                      Shadow(
                        offset: Offset(4, 4),
                        blurRadius: 2,
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),

                // User and Admin Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // User Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/adminRegister');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6B65B7), // Matching button color
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // Rounded button
                        ),
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.2),
                      ),
                      child: Text(
                        "Admin",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 40),

                    // Admin Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/userRegister');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6B65B7), // Matching button color
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // Rounded button
                        ),
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.2),
                      ),
                      child: Text(
                        "User",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}