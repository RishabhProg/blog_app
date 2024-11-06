import 'package:blogger/home.dart';
import 'package:blogger/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signupUser() async {
    print("in func");

    if (_formKey.currentState!.validate()) {
      print("inside form");
      final String username = _usernameController.text;
      final String email = _emailController.text;
      final String password = _passwordController.text;

      var request = http.Request('POST',
          Uri.parse('https://blog-app-psi-lake.vercel.app/api/auth/register'));
      request.headers.addAll({'Content-Type': 'application/json'});

      request.body = jsonEncode({
        "username": username,
        "email": email,
        "password": password,
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);
        print("sign up successfull${jsonResponse}"); // Parse JSON response

        
        Fluttertoast.showToast(
          msg: "Sign Up successful",
          backgroundColor: Colors.green,
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );

        //   ///////////////////////////////////////////////////////////
        //   var token = jsonResponse['_id']; // Assuming the response contains a token

        // final prefs = await SharedPreferences.getInstance();
        // await prefs.setString('auth_token', token);

        //   //////////////////////////////////////////////////////////

        //   var registeredUsername = jsonResponse['username'];
        //   await prefs.setString('user_name', registeredUsername);
        //   await prefs.setString('email', email);
        //   await prefs.setString('pass', password);

        // var token = jsonResponse['token'];
        // var info = jsonResponse['info'];
        // var userId = info['_id'];
        // var registeredUsername = info['username'];
        // var registeredEmail = info['email'];

        // final prefs = await SharedPreferences.getInstance();
        // await prefs.setString('auth_token', token);
        // await prefs.setString('user_id', userId);
        // await prefs.setString('user_name', registeredUsername);
        // await prefs.setString('user_email', registeredEmail);
        // await prefs.setString('email', email);
        // await prefs.setString('pass', password);

        // print("Welcome: $registeredUsername");
        // print(token);

        // Fluttertoast.showToast(
        //   msg: "Sign Up successful",
        //   backgroundColor: Colors.green,
        // );

        // print("Signup successful: $responseBody");
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => Home(
        //             id: userId,
        //             userName: username,
        //             email: email,
        //             pass: password,
        //             token: token,
        //           )),
        // );
      } else {
        Fluttertoast.showToast(
          msg: "Sign Up Failed",
          backgroundColor: Colors.red,
        );

        print("Signup failed: ${response.reasonPhrase}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Sign up",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple),
              ),
              const SizedBox(height: 30),
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
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
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
                    return 'Please enter an email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                style:
                    const TextStyle(color: Color.fromARGB(255, 249, 251, 253)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _signupUser,
                icon: const Icon(
                  Icons.login,
                  color: Color.fromRGBO(251, 250, 250, 1),
                ),
                label: const Text(
                  "Sign Up",
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
            ],
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
