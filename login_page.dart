import 'package:flutter/material.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'signup_page.dart';
import 'cover.dart'; // Import the file containing SplashScreen
import 'codeverify.dart'; // Import the file containing ForgotPasswordScreen

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Navigate to the SplashScreen page on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()),
      );
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuth-specific exceptions
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
          break;
      }
      _showErrorDialog(errorMessage);
    } catch (e) {
      // Handle other exceptions
      _showErrorDialog('An unexpected error occurred. Please try again.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Login Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2862A4),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/logo.png', // Replace with your logo path
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2862A4),
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton(
                              onPressed: signIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2862A4),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Next'),
                            ),
                            const SizedBox(height: 16),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text("Don't have an account? "),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SignUpPage(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Sign up",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Navigate to ForgotPasswordScreen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPasswordScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Forgot Password?",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
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
