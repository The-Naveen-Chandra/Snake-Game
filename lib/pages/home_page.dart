import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snake_game/components/components.dart';

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
    gameHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        // keep the snake moving
        moveSnake();

        // check if the game is over
        if (gameOver()) {
          timer.cancel();

          // display a message to the user
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: const Text("GAME OVER"),
                content: Column(
                  children: [
                    Text(
                      "Your score is: $currentScore",
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        hintText: "Enter name",
                      ),
                    ),
                  ],
                ),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      submitScore;
                      Navigator.pop(context);
                      newGame();
                    },
                    color: Colors.pink,
                    child: const Text(
                      "Submit",
                    ),
                  ),
                ],
              );
            },
          );
        }
      });
    });
  }

  // submit score
  void submitScore() {
    // add data to firebase
  }

  // start the new game
  void newGame() {
    setState(() {
      snakePos = [
        0,
        1,
        2,
      ];
      foodPos = 55;
      currentDirection = snake_Direction.RIGHT;
      gameHasStarted = false;
      currentScore = 0;
    });
  }

  // snake eating function
  void eatFood() {
    currentScore++;
    // making sure the new food is not where the snake is
    while (snakePos.contains(foodPos)) {
      foodPos = Random().nextInt(totalNumberOfSquares);
    }
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
        }
        break;
      case snake_Direction.UP:
        {
          //* add a head to the snake
          if (snakePos.last < rowSize) {
            snakePos.add(snakePos.last - rowSize + totalNumberOfSquares);
          } else {
            snakePos.add(snakePos.last - rowSize);
          }
        }
        break;
      case snake_Direction.DOWN:
        {
          //* add a head to the snake
          if (snakePos.last + rowSize > totalNumberOfSquares) {
            snakePos.add(snakePos.last + rowSize - totalNumberOfSquares);
          } else {
            snakePos.add(snakePos.last + rowSize);
          }
        }
        break;
      default:
    }

    // snake is eating food
    if (snakePos.last == foodPos) {
      eatFood();
    } else {
      //* remove the tail of the snake
      snakePos.removeAt(0);
    }
  }

  // game over
  bool gameOver() {
    // the game is over when the snake runs into itself
    // this occurs when the there is a duplicate position in the snakePos list

    // this list is body of the snake (no head)
    List<int> bodySnake = snakePos.sublist(0, snakePos.length - 1);

    if (bodySnake.contains(snakePos.last)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // high score
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // user current score
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Current Score",
                    ),
                    Text(
                      currentScore.toString(),
                      style: const TextStyle(
                        fontSize: 36,
                      ),
                    ),
                  ],
                ),

                // High Scores, top 5
                const Text(
                  "High Scores...",
                ),
              ],
            ),
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
                    if (snakePos.last == index) {
                      return const HeadSnakePixel();
                    } else if(snakePos.first == index) {
                      return const TailSnakePixel();
                    } else  {
                      return const SnakePixel();
                    }
                  } else if (foodPos == index) {
                    return const FoodPixel();
                  } else {
                    return const BlankPixel();
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
                  onPressed: gameHasStarted ? () {} : startGame,
                  color: gameHasStarted ? Colors.grey : Colors.pink,
                  child: const Text(
                    "PLAY",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
