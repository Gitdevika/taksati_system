import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'welcome_page.dart'; // Import the welcome page
import 'profile.dart';
import 'category.dart';



class CartPage extends StatefulWidget {
  final Uint8List? imageBytes; // The image is passed as a parameter

  CartPage({Key? key, this.imageBytes}) : super(key: key); // Nullable imageBytes

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String selectedSize = 'S'; // Default size is Small
  String selectedMaterial = 'Polyester'; // Default material is Polyester
  int selectedQuantity = 1; // Default quantity is 1

  // Map holding material types and their respective costs
  final Map<String, double> materialCosts = {
    'Polyester': 100.0,
    'Linen': 200.0,
    'Silk': 300.0,
    'Cotton': 150.0,
  };

  // Method to calculate the estimated cost based on selected material and quantity
  double getEstimatedCost() {
    return materialCosts[selectedMaterial]! * selectedQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2862A4), // Set background color to blue
      body: SafeArea(
        child: Column(
          children: [
            // Top Section with Logo and Cart Icon
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo image on the left
                  Image.asset(
                    'assets/logo.png',
                    height: 70,
                  ),
                  // Shopping cart icon on the right
                  const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 28,
                  ),
                ],
              ),
            ),

            // Display Image from previous page
            Expanded(
              child: Center(
                child: widget.imageBytes == null
                    ? Text('No image available') // Handle the null case
                    : Image.memory(widget.imageBytes!), // Display the received image
              ),
            ),

            // Size Selection
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Choose Size", // Label for size selection
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Row(
                    children: ['S', 'M', 'L']
                        .map((size) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSize = size; // Set selected size
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: selectedSize == size ? Colors.white : Colors.transparent,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white),
                                ),
                                child: Center(
                                  child: Text(
                                    size,
                                    style: TextStyle(
                                      color: selectedSize == size
                                          ? const Color(0xFF2862A4)
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),

            // Material Selection Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Material", // Label for material selection
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  // Dropdown for selecting material
                  DropdownButton<String>(
                    value: selectedMaterial,
                    dropdownColor: const Color(0xFF2862A4), // Blue dropdown background
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                    items: ['Polyester', 'Linen', 'Silk', 'Cotton']
                        .map((material) => DropdownMenuItem<String>(
                              value: material,
                              child: Text(
                                material,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedMaterial = value!; // Set selected material
                      });
                    },
                  ),
                ],
              ),
            ),

            // Quantity Selection Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Quantity", // Label for quantity selection
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  // Dropdown for selecting quantity
                  DropdownButton<int>(
                    value: selectedQuantity,
                    dropdownColor: const Color(0xFF2862A4), // Blue dropdown background
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                    items: [1, 2, 3, 4, 5]
                        .map((quantity) => DropdownMenuItem<int>(
                              value: quantity,
                              child: Text(
                                quantity.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedQuantity = value!; // Set selected quantity
                      });
                    },
                  ),
                ],
              ),
            ),

            // Estimated Cost Display
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                "Estimated Cost: \Rs.${getEstimatedCost().toStringAsFixed(2)}", // Display estimated cost
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // Buy Now Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Show the selected options in a SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Size: $selectedSize, Material: $selectedMaterial, Quantity: $selectedQuantity, Estimated Cost: \$${getEstimatedCost().toStringAsFixed(2)}",
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // White button background
                  foregroundColor: const Color(0xFF2862A4), // Blue text color
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "BUY NOW", // Button label
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

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
                  // Icons for home, menu, shipping, and profile
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
                  IconButton(
                      icon: Icon(Icons.home, color: Colors.grey),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WelcomePage()),
                        );
                      },
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
    );
  }
}