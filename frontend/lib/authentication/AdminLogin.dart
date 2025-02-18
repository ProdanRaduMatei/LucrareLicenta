import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminLogin extends StatefulWidget {
  AdminLogin({Key? key}) : super(key: key);

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final String url = "http://127.0.0.1:8080/admin/login"; // ✅ Fixed endpoint

  Future<void> save() async {
    FocusScope.of(context).unfocus();

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

      print("Response Code: ${response.statusCode}"); // ✅ Debugging
      print("Response Body: '${response.body}'"); // ✅ Debugging

      // ✅ Check if response body is empty
      if (response.body.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: Empty response from server')),
        );
        return;
      }

      var jsonResponse = json.decode(response.body); // ✅ Now Safe to Decode

      // ✅ Check for login success
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful!')),
        );
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: Invalid credentials')),
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
    return Scaffold(
      backgroundColor: Color(0xFFB1B2B5), // ✅ Background color preserved
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ Logo
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

            // ✅ Card Container
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Email Field
                    _buildTextField(
                      "Email",
                      controller: _emailController,
                      validator: (value) =>
                      (value == null || value.isEmpty) ? 'Email is required' : null,
                    ),
                    SizedBox(height: 10),

                    // ✅ Password Field
                    _buildTextField(
                      "Password",
                      controller: _passwordController,
                      isObscure: true,
                      validator: (value) =>
                      (value == null || value.isEmpty) ? 'Password is required' : null,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // ✅ Sign In Button
            _isLoading
                ? CircularProgressIndicator() // ✅ Loading Indicator
                : _buildButton(
              text: "Sign in",
              backgroundColor: Color(0xFF6B65B7),
              textColor: Colors.white,
              onPressed: save,
            ),

            SizedBox(height: 20),

            // ✅ Register Button
            // Center(
            //   child: TextButton(
            //     onPressed: () {
            //       Navigator.pushNamed(context, '/adminLogin');
            //     },
            //     child: Text(
            //       "Don't have an account? Register here",
            //       style: GoogleFonts.roboto(
            //         fontWeight: FontWeight.bold,
            //         fontSize: 20,
            //         color: Colors.white,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // ✅ Text Field with purple background
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
        style: TextStyle(color: Colors.black),
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

  // ✅ Sign-in Button
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
}