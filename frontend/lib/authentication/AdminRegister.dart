import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AdminRegister extends StatefulWidget {
  AdminRegister({Key? key}) : super(key: key);

  @override
  _AdminRegisterState createState() => _AdminRegisterState();
}

class _AdminRegisterState extends State<AdminRegister> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  final String url = "http://127.0.0.1:8080/admin/register"; // ✅ Fixed API endpoint for Android Emulator

  Future<void> save() async {
    FocusScope.of(context).unfocus(); // ✅ Hide keyboard before request

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // ✅ Save registered admin email
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('adminEmail', _emailController.text.trim());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account created successfully!')),
        );
        Navigator.pop(context); // Or navigate to dashboard
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error connecting to server: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // ✅ Hide keyboard on tap
      child: Scaffold(
        backgroundColor: Color(0xFFB1B2B5), // ✅ UNCHANGED Background color
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // ✅ Top Right Sign-in Button (NOW FIXED)
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 30),
                    child: _buildWhiteButton(
                      text: "Sign in",
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),

                SizedBox(height: 40),

                // ✅ Logo (UNCHANGED)
                Text(
                  "SEAT SURFER",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Exo2",
                    color: Color(0xFF4A477F),
                    shadows: [
                      Shadow(
                        offset: Offset(4, 4),
                        blurRadius: 2,
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // ✅ Card Container (UNCHANGED)
                Container(
                  width: 300,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  margin: EdgeInsets.only(top: 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        "Email",
                        controller: _emailController,
                        validator: (value) =>
                        (value == null || value.isEmpty) ? "Email is required" : null,
                      ),
                      SizedBox(height: 10),

                      _buildTextField(
                        "Password",
                        controller: _passwordController,
                        isObscure: true,
                        validator: (value) =>
                        (value == null || value.length < 6) ? "Password must be at least 6 characters" : null,
                      ),
                      SizedBox(height: 10),

                      _buildTextField(
                        "Confirm Password",
                        controller: _confirmPasswordController,
                        isObscure: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please confirm your password";
                          }
                          if (value != _passwordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),

                // ✅ Sign Up Button (UNCHANGED)
                _isLoading
                    ? CircularProgressIndicator()
                    : _buildButton(
                  text: "Sign up",
                  backgroundColor: Color(0xFF6B65B7),
                  textColor: Colors.white,
                  onPressed: save,
                ),

                SizedBox(height: 20),

                // ✅ Already have an account? Sign in (UNCHANGED)
                TextButton(
                  onPressed: () {
                    //go to login
                    Navigator.pushNamed(context, '/adminLogin');
                  },
                  child: Text(
                    "Already have an account? Sign in",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: "Roboto",
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ UNCHANGED Text Field Widget
  Widget _buildTextField(
      String placeholder, {
        required TextEditingController controller,
        bool isObscure = false,
        String? Function(String?)? validator,
      }) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 40,
      decoration: BoxDecoration(
        color: Color(0x806B65B7),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(bottom: 5),
        ),
        validator: validator,
      ),
    );
  }

  // ✅ UNCHANGED Button Widget
  Widget _buildButton({
    required String text,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 150,
      height: 40,
      margin: EdgeInsets.only(top: 50),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w400,
            color: textColor,
          ),
        ),
      ),
    );
  }

  // ✅ NOW ADDED: White small "Sign In" button for the top-right corner
  Widget _buildWhiteButton({
    required String text,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 45,
      height: 18,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: 12, fontFamily: "Roboto", color: textColor),
        ),
      ),
    );
  }
}