import 'package:blogger/login.dart';
import 'package:blogger/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final String id;
  final String userName;
  final String email;
  final String pass;
  final String token;
  Home(
      {super.key,
      required this.id,
      required this.userName,
      required this.email,
      required this.pass,
      required this.token
      });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    print("User logged out, token removed.");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));

    var request = http.Request('GET',
        Uri.parse('https://blog-app-psi-lake.vercel.app/api/auth/logout'));
    request.body = '''''';

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("ok");
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.only(top: 8.0), // Adjust top padding as needed
          child: Text(
            "Hello, ${widget.userName}",
            style: TextStyle(color: Colors.white),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey[700],
            child: const Icon(Icons.person, color: Colors.white),
          ),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hello ${widget.id}",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: logout,
                  child: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            right: 20,
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(35, 34, 34, 1), // Background color
                shape: BoxShape.circle, // Makes the background circular
              ),
              child: IconButton(
                onPressed: () {
                  // Your onPressed action
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Post(
                               token: widget.token,
                                id: widget.id,
                                UserName: widget.userName,
                                email: widget.email,
                                pass: widget.pass,
                              )));
                },
                icon: const Icon(
                  Icons.create,
                  color: Colors.purple, // Icon color
                ),
                iconSize: 24.0, // Icon size
                tooltip: 'Edit', // Tooltip
              ),
            ),
          ),
        ],
      ),
    );
  }
}
