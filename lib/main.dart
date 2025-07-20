import 'package:flutter/material.dart';

void main() {
  runApp(const SlidingPuzzleApp());
}

class SlidingPuzzleApp extends StatelessWidget {
  const SlidingPuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const PuzzlePage(),
    );
  }
}

class PuzzlePage extends StatefulWidget {
  const PuzzlePage({super.key});

  @override
  State<PuzzlePage> createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  final int gridSize = 3;
  late List<int> tiles;
  int moves = 0;
  bool isSwiping = false;
  Offset? swipeStart;

  @override
  void initState() {
    super.initState();
    resetPuzzle();
  }

  void resetPuzzle() {
    setState(() {
      tiles = List.generate(gridSize * gridSize, (index) => index);
      tiles.shuffle();
      while (isSolved()) {
        tiles.shuffle();
      }
      moves = 0;
    });
  }

  bool isSolved() {
    for (int i = 0; i < tiles.length - 1; i++) {
      if (tiles[i] != i + 1) return false;
    }
    return tiles.last == 0;
  }

  bool isAdjacent(int i, int j) {
    int row1 = i ~/ gridSize;
    int col1 = i % gridSize;
    int row2 = j ~/ gridSize;
    int col2 = j % gridSize;
    return (row1 == row2 && (col1 - col2).abs() == 1) ||
        (col1 == col2 && (row1 - row2).abs() == 1);
  }

  void moveTile(int index) {
    int emptyIndex = tiles.indexOf(0);
    if (isAdjacent(index, emptyIndex)) {
      setState(() {
        tiles[emptyIndex] = tiles[index];
        tiles[index] = 0;
        moves++;

        if (isSolved()) {
          Future.delayed(const Duration(milliseconds: 500), () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("🎉 Puzzle Solved!"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Congratulations! You completed the puzzle."),
                    const SizedBox(height: 10),
                    Text("Moves: $moves", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      resetPuzzle();
                    },
                    child: const Text("Play Again"),
                  ),
                ],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          });
        }
      });
    }
  }

  void _handleSwipe(DragStartDetails details, int index) {
    swipeStart = details.localPosition;
    isSwiping = true;
  }

  void _handleSwipeUpdate(DragUpdateDetails details, int index) {
    if (!isSwiping) return;

    final swipeEnd = details.localPosition;
    final dx = swipeEnd.dx - swipeStart!.dx;
    final dy = swipeEnd.dy - swipeStart!.dy;

    if (dx.abs() > 20 || dy.abs() > 20) {
      isSwiping = false;
      int emptyIndex = tiles.indexOf(0);

      // Determine swipe direction
      if (dx.abs() > dy.abs()) {
        // Horizontal swipe
        if (dx > 0) {
          // Swipe right - check if left tile is empty
          if (index % gridSize > 0 && tiles[index - 1] == 0) {
            moveTile(index);
          }
        } else {
          // Swipe left - check if right tile is empty
          if (index % gridSize < gridSize - 1 && tiles[index + 1] == 0) {
            moveTile(index);
          }
        }
      } else {
        // Vertical swipe
        if (dy > 0) {
          // Swipe down - check if top tile is empty
          if (index ~/ gridSize > 0 && tiles[index - gridSize] == 0) {
            moveTile(index);
          }
        } else {
          // Swipe up - check if bottom tile is empty
          if (index ~/ gridSize < gridSize - 1 && tiles[index + gridSize] == 0) {
            moveTile(index);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    double screenSize = MediaQuery.of(context).size.shortestSide * 0.9;
    double tileSize = screenSize / gridSize;

    return Scaffold(
      appBar: AppBar(
        title: const Text("SLIDING PUZZLE"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("How to Play"),
                  content: const Text(
                    "Slide the tiles to rearrange them in numerical order "
                        "from left to right, top to bottom with the empty space "
                        "in the bottom-right corner.\n\n"
                        "You can tap tiles or swipe in the direction you want to move them.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"),
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Moves: $moves", style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            )),
            const SizedBox(height: 10),
            Container(
              width: screenSize,
              height: screenSize,
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Stack(
                children: List.generate(gridSize * gridSize, (index) {
                  int tileValue = tiles[index];
                  if (tileValue == 0) return const SizedBox.shrink();

                  int currentRow = index ~/ gridSize;
                  int currentCol = index % gridSize;
                  int targetRow = (tileValue - 1) ~/ gridSize;
                  int targetCol = (tileValue - 1) % gridSize;

                  return AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutQuad,
                    top: currentRow * tileSize,
                    left: currentCol * tileSize,
                    child: GestureDetector(
                      onTap: () => moveTile(index),
                      onPanStart: (details) => _handleSwipe(details, index),
                      onPanUpdate: (details) => _handleSwipeUpdate(details, index),
                      onPanEnd: (_) => isSwiping = false,
                      child: Container(
                        width: tileSize - 2,
                        height: tileSize - 2,
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            children: [
                              OverflowBox(
                                alignment: Alignment(
                                  -1.0 + (2 * targetCol) / (gridSize - 1),
                                  -1.0 + (2 * targetRow) / (gridSize - 1),
                                ),
                                maxWidth: screenSize,
                                maxHeight: screenSize,
                                child: Image.asset(
                                  'assets/image.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Center(
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary.withOpacity(0.8),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$tileValue',
                                      style: TextStyle(
                                        color: colorScheme.onPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: resetPuzzle,
        icon: const Icon(Icons.refresh),
        label: const Text("Restart"),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );
  }
}