import 'dart:async';

import 'package:flutter/material.dart';
import 'package:snake_game/components/components.dart';
import 'package:snake_game/components/food_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // snake direction is initially to the right
  var currentDirection = snake_Direction.RIGHT;

  // start the game
  void startGame() {
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        moveSnake();
      });
    });
  }

  void moveSnake() {
    switch (currentDirection) {
      case snake_Direction.RIGHT:
        {
          // if snake is at the right wall, need to red-adjust
          if (snakePos.last % rowSize == 9) {
            snakePos.add(snakePos.last + 1 - rowSize);
          } else {
            //* add a head to the snake
            snakePos.add(snakePos.last + 1);
          }

          //* remove the tail of the snake
          snakePos.removeAt(0);
        }
        break;
      case snake_Direction.LEFT:
        {
          // if snake is at the right wall, need to red-adjust
          if (snakePos.last % rowSize == 0) {
            snakePos.add(snakePos.last - 1 + rowSize);
          } else {
            //* add a head to the snake
            snakePos.add(snakePos.last - 1);
          }

          //* remove the tail of the snake
          snakePos.removeAt(0);
        }
        break;
      case snake_Direction.UP:
        {
          //* add a head to the snake
          snakePos.add(snakePos.last - rowSize);

          //* remove the tail of the snake
          snakePos.removeAt(0);
        }
        break;
      case snake_Direction.DOWN:
        {
          //* add a head to the snake
          snakePos.add(snakePos.last + rowSize);

          //* remove the tail of the snake
          snakePos.removeAt(0);
        }
        break;
      default:
    }
  }

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
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                // * condition
                if (details.delta.dy > 0 &&
                    currentDirection != snake_Direction.UP) {
                  // moving down
                  // print('moving down');
                  currentDirection = snake_Direction.DOWN;
                } else if (details.delta.dy < 0 &&
                    currentDirection != snake_Direction.DOWN) {
                  //* moving up
                  // print('moving up');
                  currentDirection = snake_Direction.UP;
                }
              },
              onHorizontalDragUpdate: (details) {
                // condition
                if (details.delta.dx > 0 &&
                    currentDirection != snake_Direction.LEFT) {
                  //* moving right
                  // print('moving right');
                  currentDirection = snake_Direction.RIGHT;
                } else if (details.delta.dx < 0 &&
                    currentDirection != snake_Direction.RIGHT) {
                  //* moving left
                  // print('moving left');
                  currentDirection = snake_Direction.LEFT;
                }
              },
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
          ),

          // play button
          Expanded(
            child: Container(
              child: Center(
                child: MaterialButton(
                  onPressed: startGame,
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
