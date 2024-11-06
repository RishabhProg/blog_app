// import 'package:blogger/login.dart';
// import 'package:blogger/sign_up.dart';

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
 
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: LoginScreen(),
//     );
//   }
// }


import 'package:blogger/login.dart';
import 'package:blogger/sign_up.dart';
import 'package:blogger/home.dart'; // Assume HomeScreen exists for authenticated users

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget? initialScreen;

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    String? id = prefs.getString('user_id');
    String? username=prefs.getString('user_name');
     String? email=prefs.getString('email');
      String? password=prefs.getString('pass');

   
    if (token != null && token.isNotEmpty&&username!=null&&email!=null&&password!=null&&id!=null) {
      setState(() {
        initialScreen = Home(id: id,userName: username,email: email,pass: password,token: token,); 
      });
    } else {
      setState(() {
        initialScreen = LoginScreen(); 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    if (initialScreen == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator(color: Colors.purple,)),
        ),
      );
    }

   
    return MaterialApp(
      home: initialScreen,
    );
  }
}

