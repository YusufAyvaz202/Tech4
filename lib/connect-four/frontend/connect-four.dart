import 'package:flutter/material.dart';

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
        primarySwatch: Colors.blue,
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
 
  List<List<int>> board = List.generate(6, (_) => List.generate(7, (_) => 0));
  
  int currentPlayer = 1; 
  int? playerColor; 
  bool isGameOver = false; 

  
  void _startGame(int selectedColor) {
    setState(() {
      playerColor = selectedColor;
    });
  }


  void _resetGame() {
    setState(() {
      board = List.generate(6, (_) => List.generate(7, (_) => 0));
      currentPlayer = 1;
      playerColor = null;
      isGameOver = false;
    });
  }

 
  void _dropPiece(int col) {
    if (isGameOver) return; 

    for (int row = 5; row >= 0; row--) {
      if (board[row][col] == 0) {
        setState(() {
          board[row][col] = currentPlayer;

         
          if (_checkWinner(currentPlayer)) {
            isGameOver = true;
            String winnerText = currentPlayer == playerColor ? 'Tebrikler, Kazandın!' : 'Rakip Kazandı!';
            Color winnerColor = currentPlayer == 1 ? Colors.red : Colors.yellow[800]!;
            _showGameOverDialog(winnerText, winnerColor);
          } 
         
          else if (_checkDraw()) {
            isGameOver = true;
            _showGameOverDialog('Oyun Berabere!', Colors.blue);
          } 
        
          else {
            currentPlayer = currentPlayer == 1 ? 2 : 1;
          }
        });
        break;
      }
    }
  }

 
  bool _checkWinner(int player) {
    
    for (int r = 0; r < 6; r++) {
      for (int c = 0; c < 4; c++) {
        if (board[r][c] == player && board[r][c + 1] == player && 
            board[r][c + 2] == player && board[r][c + 3] == player) {
          return true;
        }
      }
    }

    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 7; c++) {
        if (board[r][c] == player && board[r + 1][c] == player && 
            board[r + 2][c] == player && board[r + 3][c] == player) {
          return true;
        }
      }
    }

    
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 4; c++) {
        if (board[r][c] == player && board[r + 1][c + 1] == player && 
            board[r + 2][c + 2] == player && board[r + 3][c + 3] == player) {
          return true;
        }
      }
    }

 
    for (int r = 3; r < 6; r++) {
      for (int c = 0; c < 4; c++) {
        if (board[r][c] == player && board[r - 1][c + 1] == player && 
            board[r - 2][c + 2] == player && board[r - 3][c + 3] == player) {
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

  
  void _showGameOverDialog(String title, Color color) {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          content: const Text('Yeni bir oyun başlatmak ister misin?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
                _resetGame(); 
              },
              child: const Text('Tekrar Oyna'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'Connect Four',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        actions: [
          if (playerColor != null)
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
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
          const Text(
            'Tarafını Seç!',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
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
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))
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
                  decoration: const BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))
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
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              currentPlayer == playerColor ? 'Senin Sıran' : 'Rakibin Sırası',
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold,
                color: currentPlayer == 1 ? Colors.red : Colors.yellow[700],
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
                    color: Colors.blue[700],
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
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

                      return GestureDetector(
                        onTap: () {
                          _dropPiece(col);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _getPieceColor(cellValue),
                            shape: BoxShape.circle,
                          ),
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

  
  Color _getPieceColor(int value) {
    if (value == 1) return Colors.red;
    if (value == 2) return Colors.yellow;
    return Colors.white;
  }
}