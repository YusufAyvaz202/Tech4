import 'package:flutter/material.dart';
import '../data/maze_levels.dart'; 
import '../ai/a_star_pathfinder.dart'; // AI dosyamızı içeri aktardık

class MazeGameController extends ChangeNotifier {
  int playerRow = 0;
  int playerCol = 0;
  bool isGameWon = false;
  
  int currentMazeIndex = 0; 
  int currentSteps = 0; 

  List<List<int>> maze = [];
  List<List<int>> hintPath = []; 

  MazeGameController() {
    resetGame();
  }

  void resetGame() {
    maze = MazeLevels.levels[currentMazeIndex].map((row) => List<int>.from(row)).toList();
    isGameWon = false;
    currentSteps = 0;    
    hintPath.clear();    
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
    
    currentSteps++; 
    hintPath.clear(); // Karakter hareket edince eski ipuçlarını sil

    notifyListeners(); 
  }

  // EKSİK OLAN VE HATA VERDİREN FONKSİYON BURASI
  void getHint() {
    if (isGameWon) return;

    // A* Algoritmasını çağır ve tam rotayı hesapla
    List<List<int>> fullPath = AStarPathfinder.findPath(maze, playerRow, playerCol);

    // Eğer bir yol bulunduysa
    if (fullPath.length > 1) {
      // Çıkış çok yakınsa olanı al, değilse önündeki 3 adımı al
      int takeCount = fullPath.length > 4 ? 4 : fullPath.length;
      
      // İlk elemanı (karakterin kendi konumu) atla, sonraki adımları listeye kopyala
      hintPath = fullPath.sublist(1, takeCount);
      
      notifyListeners(); // Ekranı sarıya boyaması için UI'ı uyar
    }
  }
}