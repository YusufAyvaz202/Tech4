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
      appBar: AppBar(
        title: const Text('Sudoku AI'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
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
                            "Süre: $minutes:$seconds",
                            style: const TextStyle(
                              fontSize: 20, 
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          );
                        },
                      ),
                      Selector<GameProvider, int>(
                        selector: (_, provider) => provider.mistakes,
                        builder: (context, mistakes, child) {
                          return Text(
                            "Hatalar: $mistakes/3",
                            style: TextStyle(
                              fontSize: 20, 
                              fontWeight: FontWeight.bold,
                              color: mistakes > 0 ? Colors.red.shade700 : Colors.black87,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  const BoardWidget(),
                  const SizedBox(height: 30),
                  
                  // The AI Hint Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.lightbulb),
                      label: const Text(
                        'Get AI Hint',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        context.read<GameProvider>().useHint();
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 10), // Spacing between buttons
                  
                  // --- NEW AUTO SOLVE BUTTON ---
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
                        backgroundColor: Colors.purple.shade400,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        context.read<GameProvider>().solveEntirePuzzle();
                      },
                    ),
                  ),
                  // -----------------------------
                  
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
        title: Text(
          isWon ? 'Tebrikler! 🎉' : 'Oyun Bitti ❌',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isWon ? Colors.green : Colors.red,
          ),
        ),
        content: Text(
          isWon 
              ? 'Sudoku bulmacasını başarıyla çözdünüz!' 
              : '3 hata yaptığınız için oyunu kaybettiniz.',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Main Menu action is left empty for now
            },
            child: const Text('Ana Menü'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              if (isWon) {
                context.read<GameProvider>().startNextLevel();
              } else {
                context.read<GameProvider>().loadPuzzle();
              }
            },
            child: Text(isWon ? 'Sonraki Seviye' : 'Tekrar Dene'),
          ),
        ],
      ),
    );
  }
}