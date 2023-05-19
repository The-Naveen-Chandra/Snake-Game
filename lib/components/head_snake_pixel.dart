import 'package:flutter/material.dart';

class HeadSnakePixel extends StatelessWidget {
  const HeadSnakePixel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
