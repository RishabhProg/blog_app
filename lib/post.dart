import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Post extends StatefulWidget {
  String id;
  String UserName;
  String email;
  String pass;
  String token;
  Post(
      {super.key,
      required this.token,
      required this.id,
      required this.UserName,
      required this.email,
      required this.pass});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  List<String> categories = [];

  void _addCategory() {
    if (_categoryController.text.isNotEmpty) {
      setState(() {
        categories.add(_categoryController.text.trim());
        _categoryController.clear();
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createPost() async {
    final String title = _titleController.text;
    final String description = _descriptionController.text;
    final String username = widget.UserName;
    final String userId = widget.id;

    var request = http.Request(
      'POST',
      Uri.parse('https://blog-app-psi-lake.vercel.app/api/posts/create'),
    );

    // Add headers including Authorization
    request.headers.addAll({
      'Content-Type': 'application/json',
    });

    request.body = jsonEncode({
      "title": title,
      "desc": description,
      "username": username,
      "userId": userId,
      "categories": categories,
      "token": widget.token
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("ok");
      print(await response.stream.bytesToString());
    } else {
      print("not ok");
      print(widget.token);
      print("Status Code: ${response.statusCode}");
      print("Response: ${await response.stream.bytesToString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.purple),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Create",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 28, 27, 28),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
                style:
                    const TextStyle(color: Color.fromARGB(255, 183, 179, 179)),
                maxLines: 1,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                style:
                    TextStyle(color: const Color.fromARGB(255, 207, 199, 199)),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Add Category'),
                onSubmitted: (_) => _addCategory(),
              ),
              SizedBox(height: 20),
              Wrap(
                spacing: 8.0,
                children: categories.map((category) {
                  return Chip(
                    backgroundColor: Colors.purple,
                    label: Text(category),
                    onDeleted: () {
                      setState(() {
                        categories.remove(category);
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createPost,
                child: Text('Create Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
