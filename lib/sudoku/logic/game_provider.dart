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

  // --- EKLENENLER ---
  List<List<int>>? _solutionGrid; // Doğru cevapları saklayacağımız önbellek
  final ValueNotifier<int> elapsedTime = ValueNotifier<int>(0); // Sadece arayüzdeki sayacı tetikler
  Timer? _timer;
  // ------------------

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
      
      // OPTİMİZASYON: Tahta yüklendiği an çözümü bul ve kaydet.
      // Artık oyun esnasında kasma olmayacak.
      _solutionGrid = SudokuAI.getSolution(board!);
      
      selectedRow = null;
      selectedCol = null;
      
      // Oyunu yükledikten sonra sayacı başlat
      _startTimer();
      
    } catch (e) {
      debugPrint("Error loading puzzle JSON: $e");
    } finally {
      isLoading = false;
      notifyListeners(); 
    }
  }

  void _startTimer() {
    _timer?.cancel();
    elapsedTime.value = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsedTime.value++; // Her saniye sadece bu değişkeni artırır, tüm tahtayı yenilemez
    });
  }

  void selectCell(int row, int col) {
    if (selectedRow != null && selectedCol != null) {
      board!.grid[selectedRow!][selectedCol!].isSelected = false;
    }
    selectedRow = row;
    selectedCol = col;
    board!.grid[row][col].isSelected = true;
    
    notifyListeners();
  }

  void inputNumber(int number) {
    if (board == null || selectedRow == null || selectedCol == null) return;
    var currentCell = board!.grid[selectedRow!][selectedCol!];
    if (currentCell.isFixed) return;

    currentCell.value = number;

    // KASMA ÇÖZÜMÜ: AI'yi tekrar çalıştırmak yerine doğrudan önbellekteki çözümle karşılaştırıyoruz.
    int? correctAnswer = _solutionGrid?[selectedRow!][selectedCol!];
    currentCell.isWrong = (number != correctAnswer);

    notifyListeners();
    _checkWinCondition();
  }

  void eraseNumber() {
    if (board == null || selectedRow == null || selectedCol == null) return;
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

    if (isComplete) {
      _timer?.cancel(); // Oyun bitince süreyi durdur
      debugPrint("YOU WIN!");
    }
  }

  void useHint() {
    if (board == null || selectedRow == null || selectedCol == null) return;
    var currentCell = board!.grid[selectedRow!][selectedCol!];
    if (currentCell.isFixed) return;

    // AI çalıştırmıyoruz, direkt önbellekten cevabı alıyoruz.
    int? hintValue = _solutionGrid?[selectedRow!][selectedCol!];

    if (hintValue != null) {
      currentCell.value = hintValue;
      currentCell.isWrong = false;
      notifyListeners();
      _checkWinCondition();
    }
  }

  // Bellek sızıntılarını (memory leak) önlemek için eklendi
  @override
  void dispose() {
    _timer?.cancel();
    elapsedTime.dispose();
    super.dispose();
  }
}