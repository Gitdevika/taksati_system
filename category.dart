import 'package:flutter/material.dart';
import 'design_page.dart';  // Import the design_page.dart
import 'welcome_page.dart'; // Import the welcome page
import 'profile.dart'; 


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CategorySelectionScreen(),
    );
  }
}

class CategorySelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2862A4),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/logo.png',
                  height: 100,
                ),
              ),
              SizedBox(height: 48),
              Text(
                'Select your category',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 48),
              _buildCategoryIcon(context, 'assets/dress.png', 'Dress'),
              SizedBox(height: 24),
              _buildCategoryIcon(context, 'assets/top.png', 'Top'),
              SizedBox(height: 24),
              _buildCategoryIcon(context, 'assets/bottom.png', 'Bottom'),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    Icon(Icons.menu, color: Colors.grey),
                    
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
    );
  }

  Widget _buildCategoryIcon(BuildContext context, String imagePath, String label) {
  return GestureDetector(
    onTap: () {
      String templateImagePath;

      // Determine the template image path based on the label
      switch (label) {
        case 'Top':
          templateImagePath = 'assets/top.png';
          break;
        case 'Dress':
          templateImagePath = 'assets/dress.png';
          break;
        case 'Bottom':
          templateImagePath = 'assets/bottom.png';
          break;
        default:
          templateImagePath = 'assets/top.png'; // Fallback option
      }

      // Pass the selected image to the ShirtDesignerPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ShirtDesignerPage(templateImage: templateImagePath),
        ),
      );
    },
    child: Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: ClipOval(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Image.asset(
                imagePath,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ],
    ),
  );
}
}