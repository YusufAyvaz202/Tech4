import 'package:flutter/material.dart';
import '../AI/minimax_ai.dart'; 

void main() {
  runApp(const ConnectFourApp());
}

class ConnectFourApp extends StatelessWidget {
  const ConnectFourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Connect Four',
      theme: ThemeData(
        fontFamily: 'Roboto', 
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final Color bgDeepSlate = const Color(0xFF121826);
  final Color boardCharcoal = const Color(0xFF1E2640);
  final Color gridGrey = const Color(0xFF3A4454);
  final Color p1Coral = const Color(0xFFFF6B6B);
  final Color p2Teal = const Color(0xFF00F5D4);
  final Color textOffWhite = const Color(0xFFF8FAFC);
  final Color textSlate = const Color(0xFF94A3B8);

  List<List<int>> board = List.generate(6, (_) => List.generate(7, (_) => 0));
  
  int currentPlayer = 1; 
  int? playerColor; 
  bool isGameOver = false; 
  
  bool isAiThinking = false;
  late ConnectFourAI ai; 

  List<int> winPath = []; 
  List<int> hintColumns = []; 

  void _startGame(int selectedColor) {
    setState(() {
      playerColor = selectedColor;
      int aiColor = selectedColor == 1 ? 2 : 1;
      ai = ConnectFourAI(aiPiece: aiColor, playerPiece: selectedColor);

      if (currentPlayer == aiColor) {
        _makeAiMove();
      }
    });
  }

  void _resetGame() {
    setState(() {
      board = List.generate(6, (_) => List.generate(7, (_) => 0));
      currentPlayer = 1;
      playerColor = null;
      isGameOver = false;
      isAiThinking = false;
      winPath.clear(); 
      hintColumns.clear(); 
    });
  }

  void _handleTap(int col) {
    if (isGameOver || isAiThinking || currentPlayer != playerColor) return;
    
    setState(() {
      hintColumns.clear(); 
    });
    
    _processDrop(col);
  }

  void _makeAiMove() async {
    setState(() { isAiThinking = true; }); 

    await Future.delayed(const Duration(milliseconds: 600));
    
    
    AiMove bestMove = ai.getBestMove(board, 3, -99999999, 99999999, true);

    setState(() { isAiThinking = false; }); 
    
    if (bestMove.column != -1) {
      _processDrop(bestMove.column);
    }
  }

  void _processDrop(int col) {
    for (int row = 5; row >= 0; row--) {
      if (board[row][col] == 0) {
        setState(() {
          board[row][col] = currentPlayer;

          if (_checkWinner(currentPlayer)) {
            isGameOver = true;
            String winnerText = currentPlayer == playerColor ? 'Tebrikler, Kazandın!' : 'Yapay Zeka Kazandı!';
            Color winnerColor = currentPlayer == 1 ? p1Coral : p2Teal;
            
            Future.delayed(const Duration(milliseconds: 800), () {
              _showGameOverDialog(winnerText, winnerColor);
            });
            
          } else if (_checkDraw()) {
            isGameOver = true;
            Future.delayed(const Duration(milliseconds: 800), () {
              _showGameOverDialog('Oyun Berabere!', textOffWhite);
            });
          } else {
            currentPlayer = currentPlayer == 1 ? 2 : 1;
            
            if (currentPlayer != playerColor) {
              _makeAiMove();
            }
          }
        });
        break;
      }
    }
  }

  bool _checkWinner(int player) {
    winPath.clear(); 

    for (int r = 0; r < 6; r++) {
      for (int c = 0; c < 4; c++) {
        if (board[r][c] == player && board[r][c + 1] == player && board[r][c + 2] == player && board[r][c + 3] == player) {
          winPath = [r * 7 + c, r * 7 + (c + 1), r * 7 + (c + 2), r * 7 + (c + 3)];
          return true;
        }
      }
    }
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 7; c++) {
        if (board[r][c] == player && board[r + 1][c] == player && board[r + 2][c] == player && board[r + 3][c] == player) {
          winPath = [r * 7 + c, (r + 1) * 7 + c, (r + 2) * 7 + c, (r + 3) * 7 + c];
          return true;
        }
      }
    }
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 4; c++) {
        if (board[r][c] == player && board[r + 1][c + 1] == player && board[r + 2][c + 2] == player && board[r + 3][c + 3] == player) {
          winPath = [r * 7 + c, (r + 1) * 7 + (c + 1), (r + 2) * 7 + (c + 2), (r + 3) * 7 + (c + 3)];
          return true;
        }
      }
    }
    for (int r = 3; r < 6; r++) {
      for (int c = 0; c < 4; c++) {
        if (board[r][c] == player && board[r - 1][c + 1] == player && board[r - 2][c + 2] == player && board[r - 3][c + 3] == player) {
          winPath = [r * 7 + c, (r - 1) * 7 + (c + 1), (r - 2) * 7 + (c + 2), (r - 3) * 7 + (c + 3)];
          return true;
        }
      }
    }
    return false;
  }

  bool _checkDraw() {
    for (int r = 0; r < 6; r++) {
      for (int c = 0; c < 7; c++) {
        if (board[r][c] == 0) return false; 
      }
    }
    return true; 
  }

  int _getEmptyRow(int col) {
    for (int r = 5; r >= 0; r--) {
      if (board[r][col] == 0) return r;
    }
    return -1;
  }

  void _showGameOverDialog(String title, Color color) {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) {
        return AlertDialog(
          backgroundColor: boardCharcoal,
          title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          content: Text('Yeni bir oyun başlatmak ister misin?', style: TextStyle(color: textSlate)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
                _resetGame(); 
              },
              child: Text('Tekrar Oyna', style: TextStyle(color: textOffWhite)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDeepSlate, 
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home, color: textOffWhite),
          onPressed: () {
           
          },
          tooltip: 'Ana Menü',
        ),
        title: Text(
          'Connect Four',
          style: TextStyle(fontWeight: FontWeight.bold, color: textOffWhite),
        ),
        backgroundColor: bgDeepSlate,
        elevation: 0, 
        centerTitle: true,
        actions: [
          if (playerColor != null)
            IconButton(
              icon: const Icon(Icons.lightbulb_outline, color: Colors.yellowAccent),
              onPressed: () {
                if (isGameOver || isAiThinking || currentPlayer != playerColor) return;
                setState(() {
                  hintColumns = ai.getTopTwoMoves(board);
                });
              },
              tooltip: 'İpucu Al',
            ),
          if (playerColor != null)
            IconButton(
              icon: Icon(Icons.refresh, color: textSlate),
              onPressed: _resetGame,
              tooltip: 'Oyunu Sıfırla',
            ),
        ],
      ),
      body: playerColor == null ? _buildColorSelection() : _buildGameBoard(),
    );
  }

  Widget _buildColorSelection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Tarafını Seç',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textOffWhite),
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _startGame(1),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: p1Coral,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: p1Coral.withOpacity(0.5), blurRadius: 15, spreadRadius: 2)
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 40),
              GestureDetector(
                onTap: () => _startGame(2),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: p2Teal,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: p2Teal.withOpacity(0.5), blurRadius: 15, spreadRadius: 2)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGameBoard() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Text(
              currentPlayer == playerColor ? 'Senin Sıran' : 'Yapay Zeka Düşünüyor...',
              style: TextStyle(
                fontSize: 22, 
                fontWeight: FontWeight.w600,
                color: currentPlayer == 1 ? p1Coral : p2Teal,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Container(
                  width: 764,
                  height: 656,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: boardCharcoal, 
                    border: Border.all(color: gridGrey, width: 2), 
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: const [
                      BoxShadow(color: Colors.black45, blurRadius: 15, offset: Offset(0, 8))
                    ],
                  ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: 42,
                    itemBuilder: (context, index) {
                      int row = index ~/ 7;
                      int col = index % 7;
                      int cellValue = board[row][col];
                      
                      bool isWinningPiece = winPath.contains(index);
                      bool isHinted = hintColumns.contains(col) && row == _getEmptyRow(col);

                      return GestureDetector(
                        onTap: () {
                          _handleTap(col);
                        },
                        child: cellValue == 0
                            ? Container(
                                decoration: BoxDecoration(
                                  color: bgDeepSlate, 
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isHinted ? Colors.yellowAccent : gridGrey.withOpacity(0.3), 
                                    width: isHinted ? 3 : 1
                                  ),
                                  boxShadow: isHinted 
                                      ? [BoxShadow(color: Colors.yellowAccent.withOpacity(0.4), blurRadius: 12, spreadRadius: 2)] 
                                      : [],
                                ),
                                child: isHinted 
                                    ? Icon(Icons.flare, color: Colors.yellowAccent.withOpacity(0.8), size: 24)
                                    : null,
                              )
                            : AnimatedPiece(
                                player: cellValue, 
                                row: row, 
                                isWinningPiece: isWinningPiece,
                                colorP1: p1Coral,
                                colorP2: p2Teal,
                                glowColor: textOffWhite,
                              ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedPiece extends StatelessWidget {
  final int player;
  final int row; 
  final bool isWinningPiece;
  final Color colorP1;
  final Color colorP2;
  final Color glowColor;

  const AnimatedPiece({
    super.key, 
    required this.player, 
    required this.row,
    required this.isWinningPiece,
    required this.colorP1,
    required this.colorP2,
    required this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    Color pieceColor = player == 1 ? colorP1 : colorP2;

    return TweenAnimationBuilder<Offset>(
      duration: Duration(milliseconds: 400 + (row * 80)), 
      curve: Curves.bounceOut, 
      tween: Tween<Offset>(
        begin: Offset(0, -(row + 2).toDouble()), 
        end: Offset.zero, 
      ),
      builder: (context, offset, child) {
        return FractionalTranslation(
          translation: offset,
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: pieceColor,
          shape: BoxShape.circle,
          boxShadow: isWinningPiece 
              ? [
                  BoxShadow(
                    color: glowColor.withOpacity(0.8),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                  BoxShadow(
                    color: pieceColor, 
                    blurRadius: 10,
                    spreadRadius: 1,
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 3),
                  )
                ],
        ),
      ),
    );
  }
}