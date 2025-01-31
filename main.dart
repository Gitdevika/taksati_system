import 'package:flutter/material.dart'; 
// Importing Flutter's material package for building UI components.

import 'package:firebase_core/firebase_core.dart'; 
// Importing Firebase Core package for initializing Firebase.

import 'firebase_options.dart'; 
// Importing Firebase configuration options (automatically generated by FlutterFire CLI).

import 'screens/welcome_page.dart'; 
// Importing the WelcomePage screen from the 'screens' folder.

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  // Ensures Flutter framework is properly initialized before running any asynchronous operations.

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, 
      // Initializes Firebase with platform-specific configurations.
    );
    print('Firebase Initialized'); 
    // Prints a confirmation message if Firebase initialization succeeds.
  } catch (e) {
    print('Firebase Initialization Failed: $e'); 
    // Prints an error message if Firebase initialization fails.
  }

  runApp(const MyApp()); 
  // Runs the main Flutter application.
}

class MyApp extends StatelessWidget { 
  const MyApp({super.key}); 
  // Constructor for the MyApp widget, which extends StatelessWidget.

  @override
  Widget build(BuildContext context) { 
    // Builds the widget tree for the application.
    return MaterialApp(
      title: 'Flutter Firebase Auth', 
      // Sets the title of the app.

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), 
        // Configures the app's color scheme using a deep purple seed color.

        useMaterial3: true, 
        // Enables Material Design 3 styling.
      ),
      home: WelcomePage(), 
      // Sets WelcomePage as the initial screen of the app.
    );
  }
}
