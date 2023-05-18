import 'package:flutter/material.dart';
import 'package:snake_game/components/variables.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // high score
          Expanded(
            child: Container(),
          ),

          // game grid
          Expanded(
            flex: 3,
            child: GridView.builder(
              itemCount: totalNumberOfSquares,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowSize),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              },
            ),
          ),

          // play button
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }
}
