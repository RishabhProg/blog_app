// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class Post extends StatefulWidget {
//   String id;
//   String UserName;
//   String email;
//   String pass;
//   Post(
//       {super.key,
//       required this.id,
//       required this.UserName,
//       required this.email,
//       required this.pass});

//   @override
//   State<Post> createState() => _PostState();
// }

// class _PostState extends State<Post> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _categoryController = TextEditingController();
//   List<String> categories = [];

//   void _addCategory() {
//     if (_categoryController.text.isNotEmpty) {
//       setState(() {
//         categories.add(_categoryController.text.trim());
//         _categoryController.clear();
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//  Future<void> _createPost() async {
//   var loginRequest = http.Request(
//     'POST',
//     Uri.parse('https://blog-app-psi-lake.vercel.app/api/auth/login'),
//   );
//   loginRequest.headers.addAll({'Content-Type': 'application/json'});

//   loginRequest.body = jsonEncode({
//     "username": widget.UserName,
//     "email": widget.email,
//     "password": widget.pass,
//   });

//   http.StreamedResponse loginResponse = await loginRequest.send();

//   if (loginResponse.statusCode == 200) {
//     var responseBody = await loginResponse.stream.bytesToString();
//     var jsonResponse = jsonDecode(responseBody);
//     print("Login successful: $jsonResponse");
//     String token = jsonResponse['_id']; 

//     final String title = _titleController.text;
//     final String description = _descriptionController.text;
//     final String username = widget.UserName;
//     final String userId = widget.id;

//     var postRequest = http.Request(
//       'POST',
//       Uri.parse('https://blog-app-psi-lake.vercel.app/api/posts/create'),
//     );

//     postRequest.headers.addAll({
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $token',
//     });

//     postRequest.body = jsonEncode({
//       "title": title,
//       "desc": description,
//       "username": username,
//       "userId": userId,
//       "categories": categories,
//     });

//     http.StreamedResponse postResponse = await postRequest.send();
   
   
//     var postResponseBody = await postResponse.stream.bytesToString();
  
    
//     if (postResponse.statusCode == 200) {
//       print("Post created successfully!");
//       print("Response Body: $postResponseBody"); 
//     } else {
//       print("Failed to create post. Status Code: ${postResponse.statusCode}");
//       print("Response Body: $postResponseBody");
//     }
//   } else {
//     print("Login failed. Status Code: ${loginResponse.statusCode}");
//     print("Reason: ${loginResponse.reasonPhrase}");
//   }
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.purple),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text(
//           "Create",
//           style: TextStyle(
//               fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         centerTitle: true,
//         backgroundColor: Color.fromARGB(255, 28, 27, 28),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _titleController,
//                 decoration: const InputDecoration(
//                   labelText: "Title",
//                   border: OutlineInputBorder(),
//                 ),
//                 style:
//                     const TextStyle(color: Color.fromARGB(255, 183, 179, 179)),
//                 maxLines: 1,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a title';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(
//                   labelText: "Description",
//                   border: OutlineInputBorder(),
//                 ),
//                 style:
//                     TextStyle(color: const Color.fromARGB(255, 207, 199, 199)),
//                 maxLines: null,
//                 keyboardType: TextInputType.multiline,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a description';
//                   }
//                   return null;
//                 },
//               ),
//               TextField(
//                 controller: _categoryController,
//                 decoration: InputDecoration(labelText: 'Add Category'),
//                 onSubmitted: (_) => _addCategory(),
//               ),
//               SizedBox(height: 20),
//               Wrap(
//                 spacing: 8.0,
//                 children: categories.map((category) {
//                   return Chip(
//                     backgroundColor: Colors.purple,
//                     label: Text(category),
//                     onDeleted: () {
//                       setState(() {
//                         categories.remove(category);
//                       });
//                     },
//                   );
//                 }).toList(),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _createPost,
//                 child: Text('Create Post'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



// import 'package:blogger/home.dart';
// import 'package:blogger/sign_up.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:fluttertoast/fluttertoast.dart';

// import 'package:shared_preferences/shared_preferences.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   Future<void> _loginUser() async {
//     if (_formKey.currentState!.validate()) {
//       final String username = _usernameController.text;
//       final String email = _emailController.text;
//       final String password = _passwordController.text;

//       var request = http.Request('POST',
//           Uri.parse('https://blog-app-psi-lake.vercel.app/api/auth/login'));
//       request.headers.addAll({'Content-Type': 'application/json'});

//       request.body = jsonEncode({
//         "username": username,
//         "email": email,
//         "password": password,
        
//       });

//       http.StreamedResponse response = await request.send();

//       if (response.statusCode == 200) {
//         var responseBody = await response.stream.bytesToString();
//         var parsedData = jsonDecode(responseBody);
//         var cookies = response.headers;
//         print("${cookies}eufhehfhueg");
//         //////////////////////////////////////////////////////////////////////////
//         var token = parsedData['_id']; // Assuming the response contains a token
//         var registeredUsername = parsedData['username'];

//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('auth_token', token);
//         await prefs.setString('user_name', registeredUsername);
//         await prefs.setString('email', email);
//         await prefs.setString('pass', password);

//         //////////////////////////////////////////////////////////////////////////
//         print(token);
//         print("Login successful: $parsedData");
//         Fluttertoast.showToast(
//           msg: "Login successful",
//           backgroundColor: Colors.green,
//         );
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => Home(
//                     id: token,
//                     userName: username,
//                     email: email,
//                     pass: password,
//                   )),
//         );
//       } else {
//         Fluttertoast.showToast(
//           msg: "Login failed",
//           backgroundColor: Colors.red,
//         );
//         print("Login failed: ${response.reasonPhrase}");
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 "Log in",
//                 style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.purple),
//               ),
//               SizedBox(height: 20),
//               TextFormField(
//                 controller: _usernameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Username',
//                   border: OutlineInputBorder(),
//                 ),
//                 style:
//                     const TextStyle(color: Color.fromARGB(255, 249, 251, 253)),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your username';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//                 style:
//                     const TextStyle(color: Color.fromARGB(255, 249, 251, 253)),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email';
//                   } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                     return 'Please enter a valid email';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: const InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(),
//                 ),
//                 style:
//                     const TextStyle(color: Color.fromARGB(255, 249, 251, 253)),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your password';
//                   } else if (value.length < 6) {
//                     return 'Password must be at least 6 characters long';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               ElevatedButton.icon(
//                 onPressed: _loginUser,
//                 icon: const Icon(
//                   Icons.login,
//                   color: Color.fromRGBO(251, 250, 250, 1),
//                 ),
//                 label: const Text(
//                   "Log in",
//                   style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w300,
//                       color: Color.fromRGBO(248, 243, 243, 1)),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.purple,
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => SignupScreen()),
//                   );
//                 },
//                 child: const Text(
//                   "Don't have an account? Sign Up",
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.blue,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
// }
