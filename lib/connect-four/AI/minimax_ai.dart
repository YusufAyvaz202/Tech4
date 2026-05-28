import 'dart:math';

class AiMove {
  final int column;
  final int score;

  AiMove({required this.column, required this.score});
}

class ConnectFourAI {
  final int aiPiece; 
  final int playerPiece; 
  final int empty = 0;

  ConnectFourAI({required this.aiPiece, required this.playerPiece});

  List<int> _getValidLocations(List<List<int>> board) {
    List<int> validLocations = [];
    for (int col = 0; col < 7; col++) {
      if (board[0][col] == empty) {
        validLocations.add(col);
      }
    }
    return validLocations;
  }

  void _dropPiece(List<List<int>> board, int col, int piece) {
    for (int r = 5; r >= 0; r--) {
      if (board[r][col] == empty) {
        board[r][col] = piece;
        break;
      }
    }
  }

  List<List<int>> _copyBoard(List<List<int>> board) {
    return board.map((row) => List<int>.from(row)).toList();
  }

  int _evaluateWindow(List<int> window, int piece) {
    int score = 0;
    int oppPiece = (piece == playerPiece) ? aiPiece : playerPiece;

    int pieceCount = window.where((x) => x == piece).length;
    int emptyCount = window.where((x) => x == empty).length;
    int oppCount = window.where((x) => x == oppPiece).length;

    if (pieceCount == 4) {
      score += 100;
    } else if (pieceCount == 3 && emptyCount == 1) {
      score += 5;
    } else if (pieceCount == 2 && emptyCount == 2) {
      score += 2;
    }

    if (oppCount == 3 && emptyCount == 1) {
      score -= 80;
    }

    return score;
  }

  List<int> getTopTwoMoves(List<List<int>> board) {
    List<int> validLocations = _getValidLocations(board);
    List<AiMove> moves = [];

    
    for (int col in validLocations) {
      List<List<int>> bCopy = _copyBoard(board);
      _dropPiece(bCopy, col, playerPiece); 
      
      int score = 0;
      
      if (_checkWinningMove(bCopy, playerPiece)) {
        score = 100000; 
      } else {
       
        score = _scorePosition(bCopy, playerPiece);
      }
      moves.add(AiMove(column: col, score: score));
    }

    
    moves.sort((a, b) => b.score.compareTo(a.score));

    
    return moves.take(2).map((m) => m.column).toList();
  }
  int _scorePosition(List<List<int>> board, int piece) {
    int score = 0;

    List<int> centerArray = [];
    for (int r = 0; r < 6; r++) {
      centerArray.add(board[r][3]);
    }
    int centerCount = centerArray.where((x) => x == piece).length;
    score += centerCount * 3;

    for (int r = 0; r < 6; r++) {
      List<int> rowArray = board[r];
      for (int c = 0; c < 4; c++) {
        List<int> window = rowArray.sublist(c, c + 4);
        score += _evaluateWindow(window, piece);
      }
    }

    for (int c = 0; c < 7; c++) {
      List<int> colArray = [];
      for (int r = 0; r < 6; r++) {
        colArray.add(board[r][c]);
      }
      for (int r = 0; r < 3; r++) {
        List<int> window = colArray.sublist(r, r + 4);
        score += _evaluateWindow(window, piece);
      }
    }

    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 4; c++) {
        List<int> window = [board[r][c], board[r + 1][c + 1], board[r + 2][c + 2], board[r + 3][c + 3]];
        score += _evaluateWindow(window, piece);
      }
    }

    for (int r = 3; r < 6; r++) {
      for (int c = 0; c < 4; c++) {
        List<int> window = [board[r][c], board[r - 1][c + 1], board[r - 2][c + 2], board[r - 3][c + 3]];
        score += _evaluateWindow(window, piece);
      }
    }

    return score;
  }

  bool _isTerminalNode(List<List<int>> board) {
    return _checkWinningMove(board, playerPiece) ||
           _checkWinningMove(board, aiPiece) ||
           _getValidLocations(board).isEmpty;
  }

  bool _checkWinningMove(List<List<int>> board, int piece) {
    for (int c = 0; c < 4; c++) {
      for (int r = 0; r < 6; r++) {
        if (board[r][c] == piece && board[r][c + 1] == piece && board[r][c + 2] == piece && board[r][c + 3] == piece) return true;
      }
    }
    for (int c = 0; c < 7; c++) {
      for (int r = 0; r < 3; r++) {
        if (board[r][c] == piece && board[r + 1][c] == piece && board[r + 2][c] == piece && board[r + 3][c] == piece) return true;
      }
    }
    for (int c = 0; c < 4; c++) {
      for (int r = 0; r < 3; r++) {
        if (board[r][c] == piece && board[r + 1][c + 1] == piece && board[r + 2][c + 2] == piece && board[r + 3][c + 3] == piece) return true;
      }
    }
    for (int c = 0; c < 4; c++) {
      for (int r = 3; r < 6; r++) {
        if (board[r][c] == piece && board[r - 1][c + 1] == piece && board[r - 2][c + 2] == piece && board[r - 3][c + 3] == piece) return true;
      }
    }
    return false;
  }

  AiMove getBestMove(List<List<int>> board, int depth, int alpha, int beta, bool maximizingPlayer) {
    List<int> validLocations = _getValidLocations(board);
    bool isTerminal = _isTerminalNode(board);

    if (depth == 0 || isTerminal) {
      if (isTerminal) {
        if (_checkWinningMove(board, aiPiece)) {
          return AiMove(column: -1, score: 10000000);
        } else if (_checkWinningMove(board, playerPiece)) {
          return AiMove(column: -1, score: -10000000); 
        } else {
          return AiMove(column: -1, score: 0); 
        }
      } else {
        return AiMove(column: -1, score: _scorePosition(board, aiPiece));
      }
    }

    if (maximizingPlayer) {
      int value = -99999999;
      int bestCol = validLocations[Random().nextInt(validLocations.length)]; 

      for (int col in validLocations) {
        List<List<int>> bCopy = _copyBoard(board);
        _dropPiece(bCopy, col, aiPiece);
        int newScore = getBestMove(bCopy, depth - 1, alpha, beta, false).score;
        
        if (newScore > value) {
          value = newScore;
          bestCol = col;
        }
        alpha = max(alpha, value);
        if (alpha >= beta) break; 
      }
      return AiMove(column: bestCol, score: value);
    } 
    else {
      int value = 99999999;
      int bestCol = validLocations[Random().nextInt(validLocations.length)];

      for (int col in validLocations) {
        List<List<int>> bCopy = _copyBoard(board);
        _dropPiece(bCopy, col, playerPiece);
        int newScore = getBestMove(bCopy, depth - 1, alpha, beta, true).score;
        
        if (newScore < value) {
          value = newScore;
          bestCol = col;
        }
        beta = min(beta, value);
        if (alpha >= beta) break; 
      }
      return AiMove(column: bestCol, score: value);
    }
  }
}