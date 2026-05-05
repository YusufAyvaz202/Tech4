import 'package:flutter/material.dart';
import '../data/maze_levels.dart'; 

class MazeGameController extends ChangeNotifier {
  int playerRow = 0;
  int playerCol = 0;
  bool isGameWon = false;
  
  int currentMazeIndex = 0; 
  int currentSteps = 0; // Yeni: Adım sayacı

  List<List<int>> maze = [];
  List<List<int>> hintPath = []; // Yeni: İpucu koordinatlarını tutacak liste [[satir, sutun], [satir, sutun]]

  MazeGameController() {
    resetGame();
  }

  void resetGame() {
    maze = MazeLevels.levels[currentMazeIndex].map((row) => List<int>.from(row)).toList();
    isGameWon = false;
    currentSteps = 0;    // Yeni: Bölüm başında adımı sıfırla
    hintPath.clear();    // Yeni: Bölüm başında ipuçlarını temizle
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
    
    currentSteps++; // Yeni: Karakter her başarılı hareketinde adımı 1 artır
    hintPath.clear(); // Yeni: Oyuncu hareket ettiğinde eski ipucunu ekrandan sil

    notifyListeners(); 
  }
}