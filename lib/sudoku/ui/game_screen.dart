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
                  // --- EKLENEN SAYAC (TIMER) GÖSTERGESİ ---
                  ValueListenableBuilder<int>(
                    valueListenable: context.read<GameProvider>().elapsedTime,
                    builder: (context, timeInSeconds, child) {
                      final minutes = (timeInSeconds ~/ 60).toString().padLeft(2, '0');
                      final seconds = (timeInSeconds % 60).toString().padLeft(2, '0');
                      
                      return Text(
                        "$minutes:$seconds",
                        style: const TextStyle(
                          fontSize: 28, 
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  // ---------------------------------------

                  const BoardWidget(),
                  const SizedBox(height: 30),
                  
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