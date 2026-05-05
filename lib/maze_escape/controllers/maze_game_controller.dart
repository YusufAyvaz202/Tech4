import 'package:flutter/material.dart';
import '../data/maze_levels.dart'; // Yeni veri sınıfımızı dahil ettik

class MazeGameController extends ChangeNotifier {
  int playerRow = 0;
  int playerCol = 0;
  bool isGameWon = false;
  
  int currentMazeIndex = 0; 
  List<List<int>> maze = [];

  MazeGameController() {
    resetGame();
  }

  void resetGame() {
    // Haritaları artık MazeLevels sınıfından çekiyoruz
    maze = MazeLevels.levels[currentMazeIndex].map((row) => List<int>.from(row)).toList();
    isGameWon = false;
    _findPlayerStartPosition();
    notifyListeners();
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

    notifyListeners(); 
  }
}