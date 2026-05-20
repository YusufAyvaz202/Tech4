import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/game_provider.dart';
import 'board_widget.dart';
import 'number_pad_widget.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to isLoading state to show a loader while JSON is read.
    final isLoading = context.select((GameProvider p) => p.isLoading);

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
                  
                  const SizedBox(height: 20),
                  const NumberPadWidget(),
                ],
              ),
            ),
    );
  }
}