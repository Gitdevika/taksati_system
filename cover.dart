import 'package:flutter/material.dart';
import 'category.dart'; // Import your category screen
import 'welcome_page.dart'; // Import the welcome page
import 'profile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/splash.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo (Top Left)
                  Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset(
                      'assets/logo.png', // Replace with your logo path
                      height: 100,
                    ),
                  ),
                  Spacer(), // Push content to the bottom

                  // Text Content (Centered)
                  Column(
                    children: [
                      Text(
                        'Unleash',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Your Style',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'AI-Powered Custom Clothing Design at Your Fingertips!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  Spacer(), // Push bottom bar up
                  // Bottom Navigation Bar
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Home icon with navigation to WelcomePage
                    IconButton(
                      icon: Icon(Icons.home, color: Colors.grey),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WelcomePage()),
                        );
                      },
                    ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CategorySelectionScreen(),
                              ),
                            );
                          },
                          child: Icon(Icons.menu, color: Colors.grey),
                        ),
                        
                        IconButton(
                      icon: Icon(Icons.person_outline, color: Colors.grey),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfileScreen()), // Navigate to ProfilePage
                        );
                      },
                    ),
                      ],
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
