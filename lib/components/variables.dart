// grid dimensions
int rowSize = 10;
int totalNumberOfSquares = 100;

// snake position
List<int> snakePos = [
  0,
  1,
  2,
];

// food position
int foodPos = 55;

// user score
int currentScore = 0;

// game has started bool
bool gameHasStarted = false;

// snake direction
enum snake_Direction {
  UP,
  DOWN,
  LEFT,
  RIGHT,
}
