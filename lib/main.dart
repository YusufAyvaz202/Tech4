import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech4/sudoku/logic/game_provider.dart';
import 'package:tech4/sudoku/ui/game_screen.dart';

void main() {
  runApp(
    // Wrap the app with ChangeNotifierProvider for state management.
    ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: const SudokuApp(),
    ),
  );
}

class SudokuApp extends StatelessWidget {
  const SudokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sudoku AI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GameScreen(),
    );
  }
}