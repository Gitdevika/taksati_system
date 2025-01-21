import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          Icon(Icons.check_circle),
        ],
        backgroundColor: Color(0xFF2862A4), // Set the app bar color to blue
      ),
      body: user == null
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user!.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final userData = snapshot.data!.data() as Map<String, dynamic>?;

                return Container(
                  color: Color(0xFF2862A4), // Set background color to blue
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20.0),
                      // Profile icon added above the email section
                      CircleAvatar(
                        radius: 50.0,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 50.0,
                          color: Color(0xFF2862A4), // Blue icon color
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Email:',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Set text color to white
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.grey[200],
                        ),
                        child: Text(
                          user?.email ?? 'No email found', // Fetch the email directly from FirebaseAuth
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
