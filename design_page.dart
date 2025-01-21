import 'dart:typed_data'; // For handling image data as bytes
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/foundation.dart';
import 'package:stability_image_generation/stability_image_generation.dart'; // Import for image generation
import 'package:flutter/rendering.dart'; // Import for RenderRepaintBoundary
import 'package:flutter/services.dart'; // For ImageByteFormat
import 'cart.dart'; // Import for CartPage
import 'dart:ui' as ui; // Import the dart:ui library
import 'tryon.dart';  // Import the try-on page





void main() {
  runApp(MaterialApp(
    home: ShirtDesignerPage(templateImage: 'assets/top.png'), // Pass the default template image
  ));
}


class ShirtDesignerPage extends StatefulWidget {
  final String templateImage; // Add a parameter for the image path
  const ShirtDesignerPage({Key? key, required this.templateImage}) : super(key: key);

  @override
  _ShirtDesignerPageState createState() => _ShirtDesignerPageState();
}



GlobalKey repaintKey = GlobalKey();


class _ShirtDesignerPageState extends State<ShirtDesignerPage> {
  Uint8List? imageBytes; // Add this line to your class
  String selectedSize = 'S'; // Default shirt size
  Color shirtColor = Colors.white; // Initial shirt color
  List<Widget> designs = []; // List to store uploaded designs
  final ImagePicker _picker = ImagePicker();
  Widget? selectedDesign; // Track the selected element

  void deleteSelectedElement() {
    if (selectedDesign != null) {
      setState(() {
        designs.remove(selectedDesign);
        selectedDesign = null;
      });
    }
  }

  // Method to handle text addition
void addText() {
  TextEditingController textController = TextEditingController();
  Color selectedTextColor = Colors.black; // Default text color

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Enter Text"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: "Enter text to add"),
          ),
          const SizedBox(height: 16),
          // Color Picker Button
          ElevatedButton(
            onPressed: () async {
              Color? newColor = await showDialog<Color>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Pick a color"),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: selectedTextColor,
                        onColorChanged: (color) {
                          setState(() {
                            selectedTextColor = color;
                          });
                        },
                        showLabel: false,
                        pickerAreaHeightPercent: 0.8,
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Text("Done"),
                        onPressed: () {
                          Navigator.of(context).pop(selectedTextColor);
                        },
                      ),
                    ],
                  );
                },
              );
              if (newColor != null) {
                setState(() {
                  selectedTextColor = newColor;
                });
              }
            },
            child: const Text("Pick Text Color"),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text("Add Text"),
          onPressed: () {
            String inputText = textController.text;
            if (inputText.isNotEmpty) {
              setState(() {
                designs.add(ResizableAndDraggableText(
                  text: inputText,
                  textColor: selectedTextColor, // Pass selected color
                ));
              });
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}


  Future<void> uploadDesign() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final Uint8List imageBytes = await image.readAsBytes();
      setState(() {
        designs.add(ResizableAndDraggableImage(image: MemoryImage(imageBytes)));
      });
    }
  }

 void showColorPicker() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Pick a color"),
      content: ColorPicker(
        pickerColor: shirtColor,
        onColorChanged: (color) {
          setState(() {
            shirtColor = color;
          });
        },
      ),
      actions: [
        TextButton(
          child: const Text("Done"),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}

  Future<Uint8List> _generate(String query) async {
  try {
    final StabilityAI ai = StabilityAI();
    final String apiKey ='sk-JgJ83mthSzGDR7YgvBkBVxIiW5czkCH6n5d937Yx9LGWJzzP';
    final ImageAIStyle imageAIStyle = ImageAIStyle.noStyle;

    Uint8List image = await ai.generateImage(
      apiKey: apiKey,
      imageAIStyle: imageAIStyle,
      prompt: query,
    );
    return image;
  } catch (e) {
    debugPrint('Error generating image: $e');
    throw Exception('Failed to generate image. Please try again.');
  }
}



  void generateDesign() async {
  debugPrint('Opening design prompt dialog...');
  TextEditingController promptController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Enter Design Prompt"),
      content: TextField(
        controller: promptController,
        decoration: const InputDecoration(hintText: "Enter text or design idea"),
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            debugPrint('Prompt cancelled');
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text("Generate Image"),
          onPressed: () async {
            String promptText = promptController.text;
            if (promptText.isNotEmpty) {
              debugPrint('Generating image for prompt: $promptText');
              try {
                Uint8List generatedImage = await _generate(promptText);
                debugPrint('Image generated successfully');
                setState(() {
                  designs.add(ResizableAndDraggableImage(image: MemoryImage(generatedImage)));
                });
              } catch (e) {
                debugPrint('Error during image generation: $e');
              }
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    ),
  );
}
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF2862A4),
    body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 100,
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_cart, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartPage(imageBytes: imageBytes),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 100,
                  color: Color.fromARGB(100, 255, 255, 255),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.palette),
                        onPressed: showColorPicker,
                      ),
                      const Divider(),
                      ElevatedButton(
                        onPressed: uploadDesign,
                        child: const Text("Upload"),
                      ),
                      const Divider(),
                      ElevatedButton(
                        onPressed: addText,
                        child: const Text("Add Text"),
                      ),
                      const Divider(),
                      ElevatedButton(
                        onPressed: generateDesign,
                        child: const Text("Add Image"),
                      ),
                    ],
                  ),
                ),
                Expanded(
  child: RepaintBoundary(
    key: repaintKey,
    child: Stack(
      alignment: Alignment.center,
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            shirtColor,
            BlendMode.srcATop,
          ),
          child: Image.asset(
            widget.templateImage, // Use the passed template image
            width: 700,
            height: MediaQuery.of(context).size.height * 0.8,
            fit: BoxFit.contain,
          ),
        ),
        ...designs,
      ],
    ),
  ),
),

              ],
            ),
          ),
          const Divider(color: Colors.white),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      RenderRepaintBoundary boundary = repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
                      var image = await boundary.toImage(pixelRatio: 3.0);
                      image.toByteData(format: ui.ImageByteFormat.png).then((byteData) {
                        if (byteData != null) {
                          imageBytes = byteData.buffer.asUint8List();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TryOnPage(imageBytes: imageBytes!),
                            ),
                          );
                        } else {
                          debugPrint("Error: Failed to convert image to byte data.");
                        }
                      });
                    } catch (e) {
                      debugPrint("Error capturing design: $e");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2862A4),
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("TRY-ON"),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      RenderRepaintBoundary boundary = repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
                      var image = await boundary.toImage(pixelRatio: 3.0);
                      image.toByteData(format: ui.ImageByteFormat.png).then((byteData) {
                        imageBytes = byteData!.buffer.asUint8List();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartPage(imageBytes: imageBytes!),
                          ),
                        );
                      });
                    } catch (e) {
                      debugPrint("Error capturing design: $e");
                    }
                  },
                  child: const Text("ADD TO CART"),
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

// A draggable widget for uploaded designs
class ResizableAndDraggableImage extends StatefulWidget {
  final ImageProvider image;

  const ResizableAndDraggableImage({Key? key, required this.image})
      : super(key: key);

  @override
  _ResizableAndDraggableImageState createState() =>
      _ResizableAndDraggableImageState();
}

class ResizableAndDraggableText extends StatefulWidget {
  final String text;
  final Color textColor; // Add textColor parameter

  const ResizableAndDraggableText({Key? key, required this.text, required this.textColor})
      : super(key: key);

  @override
  _ResizableAndDraggableTextState createState() =>
      _ResizableAndDraggableTextState();
}

class _ResizableAndDraggableTextState extends State<ResizableAndDraggableText> {
  double x = 100; // Initial x position
  double y = 100; // Initial y position
  double fontSize = 16; // Initial font size
  bool isDragging = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onPanStart: (_) {
          setState(() {
            isDragging = true;
          });
        },
        onPanUpdate: (details) {
          if (isDragging) {
            setState(() {
              x += details.delta.dx;
              y += details.delta.dy;
            });
          }
        },
        onPanEnd: (_) {
          setState(() {
            isDragging = false;
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              widget.text,
              style: TextStyle(fontSize: fontSize, color: widget.textColor), // Apply color here
            ),
            // Resizing handle (bottom-right corner)
            Positioned(
              bottom: -10,
              right: -10,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    fontSize += details.delta.dy;
                  });
                },
                child: const Icon(
                  Icons.crop_square,
                  size: 16,
                  color: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResizableAndDraggableImageState
    extends State<ResizableAndDraggableImage> {
  double x = 100;
  double y = 100;
  double width = 150;
  double height = 150;
  bool isDragging = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onPanStart: (_) {
          setState(() {
            isDragging = true;
          });
        },
        onPanUpdate: (details) {
          if (isDragging) {
            setState(() {
              x += details.delta.dx;
              y += details.delta.dy;
            });
          }
        },
        onPanEnd: (_) {
          setState(() {
            isDragging = false;
          });
        },
        child: Stack(
          children: [
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: widget.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    width -= details.delta.dx;
                    height -= details.delta.dy;
                    x += details.delta.dx;
                    y += details.delta.dy;
                  });
                },
                child: const SizedBox(
                  width: 20,
                  height: 20,
                  child: DecoratedBox(decoration: BoxDecoration()),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    width += details.delta.dx;
                    height += details.delta.dy;
                  });
                },
                child: const SizedBox(
                  width: 20,
                  height: 20,
                  child: DecoratedBox(decoration: BoxDecoration()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
