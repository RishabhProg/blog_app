import 'package:blogger/home.dart';
import 'package:blogger/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      final String username = _usernameController.text;
      final String email = _emailController.text;
      final String password = _passwordController.text;

      var request = http.Request('POST',
          Uri.parse('https://blog-app-psi-lake.vercel.app/api/auth/login'));
      request.headers.addAll({'Content-Type': 'application/json'});

      request.body = jsonEncode({
        "username": username,
        "email": email,
        "password": password,
        
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var parsedData = jsonDecode(responseBody);
        


        // Extracting data from the parsed JSON
      var token = parsedData['token'];
      var info = parsedData['info'];
      var userId = info['_id'];
      var registeredUsername = info['username'];
      var registeredEmail = info['email'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('user_id', userId);
      await prefs.setString('user_name', registeredUsername);
      await prefs.setString('user_email', registeredEmail);
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
       
        
        //////////////////////////////////////////////////////////////////////////
        // var token = parsedData['_id']; // Assuming the response contains a token
        // var registeredUsername = parsedData['username'];

        // final prefs = await SharedPreferences.getInstance();
        // await prefs.setString('auth_token', token);
        // await prefs.setString('user_name', registeredUsername);
        // await prefs.setString('email', email);
        // await prefs.setString('pass', password);

        //////////////////////////////////////////////////////////////////////////
        
        print("Login successful: $parsedData");
        Fluttertoast.showToast(
          msg: "Login successful",
          backgroundColor: Colors.green,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Home(
                    id: userId,
                    userName: username,
                    email: email,
                    pass: password,
                    token: token,
                  )),
        );
      } else {
        Fluttertoast.showToast(
          msg: "Login failed",
          backgroundColor: Colors.red,
        );
        print("Login failed: ${response.reasonPhrase}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
        
                
        
                 SizedBox(
          width: 100,  // Set your desired width
          height: 100, // Set your desired height
          child: LottieBuilder.asset(
            "assets/login.json",
            repeat: true,
            reverse: true,
            fit: BoxFit.contain,
          ),
        ),
               const  SizedBox(height: 7,),
                const Text(
                  "Log in",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  style:
                      const TextStyle(color: Color.fromARGB(255, 249, 251, 253)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style:
                      const TextStyle(color: Color.fromARGB(255, 249, 251, 253)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  style:
                      const TextStyle(color: Color.fromARGB(255, 249, 251, 253)),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _loginUser,
                  icon: const Icon(
                    Icons.login,
                    color: Color.fromRGBO(251, 250, 250, 1),
                  ),
                  label: const Text(
                    "Log in",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: Color.fromRGBO(248, 243, 243, 1)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
                  child: const Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
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

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
