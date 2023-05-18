import 'package:flutter/material.dart';
import 'package:snake_game/components/components.dart';
import 'package:snake_game/components/food_pixel.dart';

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
                if (snakePos.contains(index)) {
                  return SnakePixel();
                } else if (foodPos == index) {
                  return FoodPixel();
                } else {
                  return BlankPixel();
                }
              },
            ),
          ),

          // play button
          Expanded(
            child: Container(
              child: Center(
                child: MaterialButton(
                  onPressed: () {},
                  child: Text(
                    "PLAY",
                  ),
                  color: Colors.pink,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
