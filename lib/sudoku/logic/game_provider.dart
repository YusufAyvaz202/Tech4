import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle to read JSON
import '../models/sudoku_board.dart';
import '../ai/sudoku_ai.dart';

class GameProvider extends ChangeNotifier {
  SudokuBoard? board;
  
  // Coordinates of the currently selected cell.
  int? selectedRow;
  int? selectedCol;
  
  // Loading state while reading JSON.
  bool isLoading = true;

  GameProvider() {
    // Automatically load a puzzle when the provider is initialized.
    loadPuzzle();
  }

  // Reads the puzzle from the JSON asset and initializes the board.
  Future<void> loadPuzzle() async {
    isLoading = true;
    notifyListeners();

    try {
      // Read JSON file from assets.
      final String response = await rootBundle.loadString('assets/puzzles.json');
      final List<dynamic> data = json.decode(response);
      
      // For now, we take the first puzzle in the list.
      // We explicitly cast the dynamic list to List<List<int>>.
      List<List<int>> boardData = List<List<int>>.from(
        data[0]['board'].map((row) => List<int>.from(row))
      );

      board = SudokuBoard.fromList(boardData);
      
      // Reset selections.
      selectedRow = null;
      selectedCol = null;
    } catch (e) {
      debugPrint("Error loading puzzle JSON: $e");
    } finally {
      isLoading = false;
      notifyListeners(); // Notify UI to redraw.
    }
  }

  // Updates the currently selected cell and triggers UI rebuild.
  void selectCell(int row, int col) {
    // Deselect previous cell if exists.
    if (selectedRow != null && selectedCol != null) {
      board!.grid[selectedRow!][selectedCol!].isSelected = false;
    }

    // Select the new cell.
    selectedRow = row;
    selectedCol = col;
    board!.grid[row][col].isSelected = true;
    
    notifyListeners();
  }

  // Called when the user presses a number button (1-9).
  void inputNumber(int number) {
    if (board == null || selectedRow == null || selectedCol == null) return;

    var currentCell = board!.grid[selectedRow!][selectedCol!];
    
    // Cannot modify fixed initial puzzle numbers.
    if (currentCell.isFixed) return;

    // Update the cell's value.
    currentCell.value = number;

    // Get the absolute correct answer from the AI to compare.
    int? correctAnswer = SudokuAI.getHint(board!, selectedRow!, selectedCol!);

    // If the user's input does not match the absolute solution, mark it as wrong.
    currentCell.isWrong = (number != correctAnswer);

    notifyListeners();
    _checkWinCondition();
  }

  // Clears the selected cell.
  void eraseNumber() {
    if (board == null || selectedRow == null || selectedCol == null) return;

    var currentCell = board!.grid[selectedRow!][selectedCol!];
    
    if (currentCell.isFixed) return;

    currentCell.value = null;
    currentCell.isWrong = false; // Reset error state.
    
    notifyListeners();
  }

  // Checks if the board is completely filled without any errors.
  void _checkWinCondition() {
    bool isComplete = true;

    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        var cell = board!.grid[r][c];
        // If there's an empty cell or a wrong cell, the game is not won yet.
        if (cell.value == null || cell.isWrong) {
          isComplete = false;
          break;
        }
      }
    }

    if (isComplete) {
      // In Phase 5, we will trigger a win dialog/animation here.
      debugPrint("YOU WIN!");
    }
  }

  // Requests a hint from the AI for the currently selected cell.
  void useHint() {
    if (board == null || selectedRow == null || selectedCol == null) return;

    var currentCell = board!.grid[selectedRow!][selectedCol!];
    
    // No need for a hint if the cell is already fixed.
    if (currentCell.isFixed) return;

    // Get the correct answer from the AI logic.
    int? hintValue = SudokuAI.getHint(board!, selectedRow!, selectedCol!);

    if (hintValue != null) {
      // Apply the hint directly to the cell and clear any error state.
      currentCell.value = hintValue;
      currentCell.isWrong = false;
      notifyListeners();
      _checkWinCondition();
    }
  }
}