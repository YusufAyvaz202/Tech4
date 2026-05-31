import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'difficulty_selection_view.dart';
import 'game_play_view.dart';
import 'minimax_ai.dart'; 

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({super.key});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  // --- Oyun Durumu (State) Değişkenleri ---
  List<String> board = List.filled(9, "");
  bool isPlayerTurn = true;
  MinimaxAI ai = MinimaxAI();
  
  int? selectedErrorRate;
  String selectedDifficultyName = "";
  List<int> winningLine = [];
  
  int playerScore = 0;
  int aiScore = 0;

  // --- İŞ MANTIKLARI (BUSINESS LOGIC) ---

  void _startGame(String difficultyName, int errorRate) {
    setState(() {
      selectedDifficultyName = difficultyName;
      selectedErrorRate = errorRate;
    });
  }

  void _backToMenu() {
    setState(() {
      selectedErrorRate = null;
      playerScore = 0;
      aiScore = 0;
      _resetGame();
    });
  }

  void _resetGame() {
    setState(() {
      board = List.filled(9, "");
      isPlayerTurn = true;
      winningLine = [];
    });
  }

  void _makeMove(int index) async {
    if (board[index] != "" || !isPlayerTurn) return;

    setState(() {
      board[index] = "X";
      isPlayerTurn = false;
    });

    if (_checkAndHandleWinner()) return;

    await Future.delayed(const Duration(milliseconds: 500));
    
    int aiMove = ai.getBestMove(board, _checkWinnerStatus, selectedErrorRate!);
    if (aiMove != -1) {
      setState(() {
        board[aiMove] = "O";
        isPlayerTurn = true;
      });
      _checkAndHandleWinner();
    }
  }

  bool _checkAndHandleWinner() {
    String winner = _checkWinnerStatus(board);
    if (winner != "") {
      _showGameOverDialog(winner);
      return true;
    }
    return false;
  }

  String _checkWinnerStatus(List<String> currentBoard) {
    List<List<int>> winConditions = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ];

    for (var condition in winConditions) {
      String a = currentBoard[condition[0]];
      if (a != "" && a == currentBoard[condition[1]] && a == currentBoard[condition[2]]) {
        return a;
      }
    }
    if (!currentBoard.contains("")) return "Draw";
    return "";
  }

  void _setWinningLine() {
    List<List<int>> winConditions = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ];
    for (var condition in winConditions) {
      String a = board[condition[0]];
      if (a != "" && a == board[condition[1]] && a == board[condition[2]]) {
        setState(() => winningLine = condition);
        break;
      }
    }
  }

  void _showGameOverDialog(String winner) {
    String title = "";
    setState(() {
      if (winner == "Draw") {
        title = "Draw!";
      } else if (winner == "X") {
        title = "You Win!";
        playerScore++;
        _setWinningLine();
      } else if (winner == "O") {
        title = "AI Win!";
        aiScore++;
        _setWinningLine();
      }
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          title: Text(title, style: const TextStyle(color: Colors.white)),
          content: const Text("Would you like to play again?", style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: const Text("Restart", style: TextStyle(color: AppColors.electricTeal)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mutedCharcoal,
      body: SafeArea(
        child: selectedErrorRate == null 
            ? DifficultySelectionView(onDifficultySelected: _startGame)
            : GamePlayView(
                board: board,
                isPlayerTurn: isPlayerTurn,
                difficultyName: selectedDifficultyName,
                playerScore: playerScore,
                aiScore: aiScore,
                winningLine: winningLine,
                onMove: _makeMove,
                onBackToMenu: _backToMenu,
              ),
      ),
    );
  }
}