import 'dart:async'; // Timer için eklendi
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import '../models/sudoku_board.dart';
import '../ai/sudoku_ai.dart';

class GameProvider extends ChangeNotifier {
  SudokuBoard? board;
  int? selectedRow;
  int? selectedCol;
  bool isLoading = true;

  List<List<int>>? _solutionGrid; 
  final ValueNotifier<int> elapsedTime = ValueNotifier<int>(0); 
  Timer? _timer;

  // --- NEW VARIABLES FOR GAME STATES ---
  int mistakes = 0;
  int maxMistakes = 3;
  bool isWon = false;
  bool isLost = false;
  // -------------------------------------

  GameProvider() {
    loadPuzzle();
  }

  Future<void> loadPuzzle() async {
    isLoading = true;
    notifyListeners();

    try {
      final String response = await rootBundle.loadString('assets/puzzles.json');
      final List<dynamic> data = json.decode(response);
      
      List<List<int>> boardData = List<List<int>>.from(
        data[0]['board'].map((row) => List<int>.from(row))
      );

      board = SudokuBoard.fromList(boardData);
      _solutionGrid = SudokuAI.getSolution(board!);
      
      // --- RESET GAME STATES ON LOAD ---
      mistakes = 0;
      isWon = false;
      isLost = false;
      // ---------------------------------

      selectedRow = null;
      selectedCol = null;
      
      _startTimer();
    } catch (e) {
      debugPrint("Error loading puzzle JSON: $e");
    } finally {
      isLoading = false;
      notifyListeners(); 
    }
  }

  // --- NEW METHOD TO HANDLE NEXT LEVEL LOGIC ---
  void startNextLevel() {
    // Placeholder for next level, currently reloads the puzzle
    loadPuzzle();
  }

  // --- NEW METHOD TO CLEAR STATUS FLAGS AFTER DIALOG SHOWS ---
  void acknowledgeResult() {
    isWon = false;
    isLost = false;
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    elapsedTime.value = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsedTime.value++; 
    });
  }

  void selectCell(int row, int col) {
    if (board == null || isLost || isWon) return;
    
    if (selectedRow != null && selectedCol != null) {
      board!.grid[selectedRow!][selectedCol!].isSelected = false;
    }
    selectedRow = row;
    selectedCol = col;
    board!.grid[row][col].isSelected = true;
    
    notifyListeners();
  }

  void inputNumber(int number) {
    // Prevent inputs if the game is already over
    if (board == null || selectedRow == null || selectedCol == null || isLost || isWon) return;
    
    var currentCell = board!.grid[selectedRow!][selectedCol!];
    if (currentCell.isFixed) return;

    currentCell.value = number;

    int? correctAnswer = _solutionGrid?[selectedRow!][selectedCol!];
    currentCell.isWrong = (number != correctAnswer);

    // --- TRACK MISTAKES AND LOSE CONDITION ---
    if (currentCell.isWrong) {
      mistakes++;
      if (mistakes >= maxMistakes) {
        isLost = true;
        _timer?.cancel();
      }
    }
    // ----------------------------------------

    notifyListeners();
    
    if (!isLost) {
      _checkWinCondition();
    }
  }

  void eraseNumber() {
    if (board == null || selectedRow == null || selectedCol == null || isLost || isWon) return;
    var currentCell = board!.grid[selectedRow!][selectedCol!];
    if (currentCell.isFixed) return;

    currentCell.value = null;
    currentCell.isWrong = false; 
    notifyListeners();
  }

  void _checkWinCondition() {
    bool isComplete = true;
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        var cell = board!.grid[r][c];
        if (cell.value == null || cell.isWrong) {
          isComplete = false;
          break;
        }
      }
    }

    // --- TRIGGER WIN STATE ---
    if (isComplete) {
      _timer?.cancel();
      isWon = true;
      notifyListeners();
    }
    // -------------------------
  }

  void useHint() {
    if (board == null || selectedRow == null || selectedCol == null || isLost || isWon) return;
    var currentCell = board!.grid[selectedRow!][selectedCol!];
    if (currentCell.isFixed) return;

    int? hintValue = _solutionGrid?[selectedRow!][selectedCol!];

    if (hintValue != null) {
      currentCell.value = hintValue;
      currentCell.isWrong = false;
      notifyListeners();
      _checkWinCondition();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    elapsedTime.dispose();
    super.dispose();
  }
}