import 'package:flutter/material.dart';

class TailSnakePixel extends StatelessWidget {
  const TailSnakePixel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
