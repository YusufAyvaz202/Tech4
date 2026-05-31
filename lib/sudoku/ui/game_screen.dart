import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/game_provider.dart';
import 'board_widget.dart';
import 'number_pad_widget.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select((GameProvider p) => p.isLoading);
    
    final isWon = context.select((GameProvider p) => p.isWon);
    final isLost = context.select((GameProvider p) => p.isLost);

    if (isWon || isLost) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        
        final checkWon = isWon;
        context.read<GameProvider>().acknowledgeResult();
        
        _showResultDialog(context, checkWon);
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121826), // Deep Slate
      appBar: AppBar(
        title: const Text('Sudoku'),
        centerTitle: true,
        backgroundColor: const Color(0xFF121826),
        foregroundColor: const Color(0xFFF8FAFC), // Off-White
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF00F5D4), // Electric Teal
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ValueListenableBuilder<int>(
                        valueListenable: context.read<GameProvider>().elapsedTime,
                        builder: (context, timeInSeconds, child) {
                          final minutes = (timeInSeconds ~/ 60).toString().padLeft(2, '0');
                          final seconds = (timeInSeconds % 60).toString().padLeft(2, '0');
                          
                          return Text(
                            "Time: $minutes:$seconds",
                            style: const TextStyle(
                              fontSize: 20, 
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF8FAFC), // Off-White
                            ),
                          );
                        },
                      ),
                      Selector<GameProvider, int>(
                        selector: (_, provider) => provider.mistakes,
                        builder: (context, mistakes, child) {
                          return Text(
                            "Mistakes: $mistakes/3",
                            style: TextStyle(
                              fontSize: 20, 
                              fontWeight: FontWeight.bold,
                              color: mistakes > 0 
                                  ? const Color(0xFFFF6B6B) // Neon Coral
                                  : const Color(0xFFF8FAFC), // Off-White
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  const BoardWidget(),
                  const SizedBox(height: 30),
                  
                  // AI Hint Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.lightbulb_outline),
                      label: const Text(
                        'Get AI Hint',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3A4454), // Cool Grey
                        foregroundColor: const Color(0xFF00F5D4), // Electric Teal
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        context.read<GameProvider>().useHint();
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Auto Solve Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text(
                        'Solve Entire Puzzle',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3A4454), // Cool Grey
                        foregroundColor: const Color(0xFFFF6B6B), // Neon Coral
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        context.read<GameProvider>().solveEntirePuzzle();
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  const NumberPadWidget(),
                ],
              ),
            ),
    );
  }

  void _showResultDialog(BuildContext context, bool isWon) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1E2640), // Muted Charcoal
        title: Text(
          isWon ? 'Congratulations! 🎉' : 'Game Over ❌',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isWon ? const Color(0xFF00F5D4) : const Color(0xFFFF6B6B),
          ),
        ),
        content: Text(
          isWon 
              ? 'You have successfully solved the Sudoku puzzle!' 
              : 'You lost the game because you made 3 mistakes.',
          style: const TextStyle(fontSize: 16, color: Color(0xFFF8FAFC)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Main Menu', style: TextStyle(color: Color(0xFF94A3B8))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3A4454),
              foregroundColor: const Color(0xFFF8FAFC),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              if (isWon) {
                context.read<GameProvider>().startNextLevel();
              } else {
                context.read<GameProvider>().loadPuzzle();
              }
            },
            child: Text(isWon ? 'Next Level': 'Try Again'),
          ),
        ],
      ),
    );
  }
}