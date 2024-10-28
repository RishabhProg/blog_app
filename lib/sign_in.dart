import 'package:blogger/sign_up.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Sign In",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,color: Colors.purple),
            ),
            const SizedBox(height: 30),
           const  TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
             const TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 30),
             ElevatedButton.icon(
                onPressed: () {
                  // Navigator.push(
                  //     context, MaterialPageRoute(builder: (context) => shop()));
                },
                icon: const Icon(
                  Icons.login,
                  color: Color.fromRGBO(251, 250, 250, 1),
                ),
                label: const Text(
                  "Sign In",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Color.fromRGBO(248, 243, 243, 1)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:  Colors.purple,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30.0), 
                  ),
                ),
              ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
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
    );
  }
}
