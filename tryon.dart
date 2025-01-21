import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TryOnPage extends StatefulWidget {
  final Uint8List imageBytes; // Image of the shirt design

  const TryOnPage({Key? key, required this.imageBytes}) : super(key: key);

  @override
  _TryOnPageState createState() => _TryOnPageState();
}

class _TryOnPageState extends State<TryOnPage> {
  Uint8List? userImage; // To store the user's uploaded image

  final ImagePicker _picker = ImagePicker(); // Image picker for the user image

  // Method to pick an image from the gallery
  Future<void> pickUserImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Directly await within setState
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        userImage = Uint8List.fromList(bytes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Virtual Try-On"),
        backgroundColor: const Color(0xFF2862A4),
      ),
      body: Container(
        color: const Color(0xFF2862A4), // Set background color to blue
        child: SafeArea(
          child: SingleChildScrollView( // Add this to allow scrolling if content overflows
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Button to pick user image
                ElevatedButton(
                  onPressed: pickUserImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2862A4),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Upload Your Image"),
                ),
                const SizedBox(height: 20),
                // Display the uploaded user image or a placeholder
                userImage == null
                    ? const Center(child: Text("No image selected", style: TextStyle(color: Colors.white)))
                    : Image.memory(
                        userImage!,
                        width: MediaQuery.of(context).size.width * 0.8, // Limit the width
                        height: MediaQuery.of(context).size.height * 0.4, // Limit the height
                        fit: BoxFit.contain,
                      ),
                const SizedBox(height: 20),
                // Display the shirt design over the user image if available
                if (userImage != null)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.memory(
                        userImage!,
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.4,
                        fit: BoxFit.contain,
                      ),
                      Positioned(
                        bottom: 0,
                        child: Image.memory(
                          widget.imageBytes,
                          width: MediaQuery.of(context).size.width * 0.9, // Adjust size of the shirt design
                          height: MediaQuery.of(context).size.height * 0.6, // Adjust height accordingly
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
