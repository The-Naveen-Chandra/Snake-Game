import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snake_game/components/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // game setting
  final _nameController = TextEditingController();

  // high score list
  List<String> highScore_DocIds = [];
  late final Future? letsGetDocIds;

  // snake direction is initially to the right
  var currentDirection = snake_Direction.RIGHT;

  @override
  void initState() {
    letsGetDocIds = getDocId();
    super.initState();
  }

  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection("highscores")
        .orderBy("score", descending: true)
        .limit(10)
        .get()
        .then((value) => value.docs.forEach((element) {
              highScore_DocIds.add(element.reference.id);
            }));
  }

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
                title: const Center(
                  child: Text(
                    "GAME OVER",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                content: Column(
                  children: [
                    Text(
                      "Your Score is: $currentScore",
                    ),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: "Enter name",
                      ),
                    ),
                  ],
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          newGame();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(
                            Colors.grey.shade900,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                          ),
                        ),
                        // color: Colors.pink,
                        child: Text(
                          "Try Again",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          submitScore;
                          Navigator.pop(context);
                          newGame();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll<Color>(
                            Colors.pink,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                          ),
                        ),
                        // color: Colors.pink,
                        child: Text(
                          "Submit",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
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
    // get access to the collection
    var database = FirebaseFirestore.instance;

    // add data to firebase
    database.collection("highscores").add({
      "name": _nameController.text,
      "score": currentScore,
    });

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
    // get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width: screenWidth > 400 ? 400 : screenWidth,
          child: Column(
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
                        Text(
                          "Current Score",
                          style: GoogleFonts.robotoMono(),
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
                    Expanded(
                      child: FutureBuilder(
                        future: letsGetDocIds,
                        builder: (context, snapshot) {
                          return ListView.builder(
                            itemCount: highScore_DocIds.length,
                            itemBuilder: ((context, index) {
                              return Text(highScore_DocIds[index]);
                            }),
                          );
                        },
                      ),
                    )
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
                        } else if (snakePos.first == index) {
                          return const TailSnakePixel();
                        } else {
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
                    child: TextButton(
                      onPressed: gameHasStarted ? () {} : startGame,
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                          gameHasStarted ? Colors.grey : Colors.pink,
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                      ),
                      // color: Colors.pink,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Play",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
