import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add Firebase Auth package

void main() {
  runApp(MaterialApp(
    home: ForgotPasswordScreen(),
    routes: {
      '/signup': (context) => ForgotPasswordScreen(),
    },
  ));
}

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance; // FirebaseAuth instance

  Future<void> _sendPasswordResetEmail() async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your email')),
      );
      return;
    }

    try {
      // Send password reset link
      await _auth.sendPasswordResetEmail(email: email);

      // If email is valid, show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset link sent to email!')),
      );
    } catch (e) {
      // Check for specific errors
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Email not registered')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.message}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unexpected error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2862A4),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/logo.png', // Replace with your logo
                    height: 100,
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, right: 20),
                      
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Forgot Password',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2862A4),
                              ),
                            ),
                            SizedBox(height: 16),
                            // Email TextField
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: 'Enter your email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: 16),
                            // Send Reset Link Button
                            ElevatedButton(
                              onPressed: _sendPasswordResetEmail,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF2862A4),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text('Send'),
                            ),
                           SizedBox(height: 16),
                            Center(
                              child: Text(
                                'A reset link will be sent to your email.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}