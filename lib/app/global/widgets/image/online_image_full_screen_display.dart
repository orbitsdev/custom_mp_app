

import 'package:flutter/material.dart';

class OnlineImageFullScreenDisplay extends StatelessWidget {
  final String? imageUrl;

  OnlineImageFullScreenDisplay({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Add an AppBar for navigation and aesthetics
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.black, // Set background color to black for full-screen effect
      body: Center(
        child: Image.network(
          imageUrl ?? 'https://thumbs.dreamstime.com/b/abstract-stained-pattern-rectangle-background-blue-sky-over-fiery-red-orange-color-modern-painting-art-watercolor-effe-texture-123047399.jpg',
          fit: BoxFit.contain, // Adjust the fit as needed
        ),
      ),
    );
  }
}
