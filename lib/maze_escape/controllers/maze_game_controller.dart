import 'package:flutter/material.dart';
import '../data/maze_levels.dart'; 
import '../ai/a_star_pathfinder.dart'; 

class MazeGameController extends ChangeNotifier {
  int playerRow = 0;
  int playerCol = 0;
  bool isGameWon = false;
  
  int currentMazeIndex = 0; 
  int currentSteps = 0; 
  int optimalSteps = 0; // Yeni: A* algoritmasının bulduğu kusursuz adım sayısı

  List<List<int>> maze = [];
  List<List<int>> hintPath = []; 
  
  bool _isHintAnimating = false; 

  MazeGameController() {
    resetGame();
  }

  void resetGame() {
    maze = MazeLevels.levels[currentMazeIndex].map((row) => List<int>.from(row)).toList();
    isGameWon = false;
    currentSteps = 0;    
    hintPath.clear();
    _isHintAnimating = false;
    _findPlayerStartPosition();
    _calculateOptimalSteps(); // Bölüm başlarken A* rotasını arka planda hesapla
    notifyListeners();
  }

  // A* algoritmasını başlangıçta çalıştırıp en kısa yolu bulur
  void _calculateOptimalSteps() {
    List<List<int>> fullPath = AStarPathfinder.findPath(maze, playerRow, playerCol);
    // Yol listesi, karakterin kendi durduğu kareyi de (ilk eleman) içerdiği için 1 çıkarıyoruz
    optimalSteps = fullPath.isNotEmpty ? fullPath.length - 1 : 0;
  }

  void loadNextMaze() {
    currentMazeIndex = (currentMazeIndex + 1) % MazeLevels.levels.length;
    resetGame();
  }

  void _findPlayerStartPosition() {
    for (int i = 0; i < maze.length; i++) {
      for (int j = 0; j < maze[i].length; j++) {
        if (maze[i][j] == 2) {
          playerRow = i;
          playerCol = j;
          return;
        }
      }
    }
  }

  void movePlayer(int rowOffset, int colOffset) {
    if (isGameWon) return; 

    int newRow = playerRow + rowOffset;
    int newCol = playerCol + colOffset;

    if (newRow < 0 || newRow >= maze.length || newCol < 0 || newCol >= maze[0].length) return;
    if (maze[newRow][newCol] == 1) return;

    if (maze[newRow][newCol] == 3) {
      isGameWon = true; 
    }

    maze[playerRow][playerCol] = 0; 
    playerRow = newRow;             
    playerCol = newCol;
    maze[playerRow][playerCol] = 2; 
    
    currentSteps++; 
    
    _isHintAnimating = false; 
    hintPath.clear(); 

    notifyListeners(); 
  }

  Future<void> getHint() async {
    if (isGameWon || _isHintAnimating) return;

    List<List<int>> fullPath = AStarPathfinder.findPath(maze, playerRow, playerCol);

    if (fullPath.length > 1) {
      int takeCount = fullPath.length > 6 ? 6 : fullPath.length;
      List<List<int>> stepsToAnimate = fullPath.sublist(1, takeCount);
      
      _isHintAnimating = true;
      hintPath.clear();

      for (var step in stepsToAnimate) {
        if (!_isHintAnimating) break; 

        hintPath.add(step);
        notifyListeners(); 
        
        await Future.delayed(const Duration(milliseconds: 250)); 
      }
      
      _isHintAnimating = false; 
    }
  }
}