import 'package:flutter/material.dart';

class MazeGameController extends ChangeNotifier {
  int playerRow = 0;
  int playerCol = 0;
  bool isGameWon = false;
  
  int currentMazeIndex = 0; // Hangi haritada olduğumuzu takip eder

  List<List<int>> maze = [];
  
  // 10 Farklı Seviye: 4 Kolay, 3 Orta, 3 Zor
  final List<List<List<int>>> _mazes = [
    // --- KOLAY SEVİYELER (1-4) ---
    // Seviye 1: Isınma turu, basit patika
    [
      [2, 0, 0, 1, 0, 0, 0, 1, 0, 0],
      [1, 1, 0, 1, 0, 1, 0, 1, 0, 1],
      [0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
      [0, 1, 1, 1, 1, 1, 1, 1, 1, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 1, 0],
      [1, 1, 1, 1, 0, 1, 1, 0, 1, 0],
      [0, 0, 0, 1, 0, 0, 1, 0, 0, 0],
      [0, 1, 0, 1, 1, 0, 1, 1, 1, 1],
      [0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 1, 1, 1, 1, 1, 1, 1, 0, 3], 
    ],
    // Seviye 2: Zikzaklı, çıkmaz sokak yok
    [
      [2, 1, 0, 0, 0, 0, 1, 0, 0, 0],
      [0, 1, 0, 1, 1, 0, 1, 0, 1, 0],
      [0, 0, 0, 1, 0, 0, 1, 0, 1, 0],
      [1, 1, 1, 1, 0, 1, 1, 0, 1, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 1, 0],
      [0, 1, 1, 1, 1, 1, 1, 1, 1, 0],
      [0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
      [1, 1, 1, 0, 1, 0, 1, 1, 1, 1],
      [0, 0, 1, 0, 0, 0, 1, 0, 0, 3],
      [0, 1, 1, 1, 1, 1, 1, 0, 1, 1],
    ],
    // Seviye 3: Kapalı oda mantığı, kenarları takip etme
    [
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [2, 0, 0, 0, 1, 0, 0, 0, 0, 1],
      [1, 1, 1, 0, 1, 0, 1, 1, 0, 1],
      [1, 0, 0, 0, 1, 0, 1, 1, 0, 1],
      [1, 0, 1, 1, 1, 0, 0, 0, 0, 1],
      [1, 0, 0, 0, 0, 0, 1, 1, 1, 1],
      [1, 1, 1, 1, 1, 0, 1, 0, 0, 1],
      [1, 0, 0, 0, 1, 0, 1, 0, 1, 1],
      [1, 0, 1, 0, 0, 0, 0, 0, 3, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    ],
    // Seviye 4: Kısa engeller
    [
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 2, 0, 0, 0, 0, 0, 1, 0, 1],
      [1, 1, 1, 1, 1, 1, 0, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 1, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 1, 0, 0, 0, 0, 0, 3, 1],
      [1, 0, 0, 0, 1, 1, 1, 1, 1, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    ],

    // --- ORTA SEVİYELER (5-7) ---
    // Seviye 5: Yanıltıcı çıkmazlar
    [
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [2, 0, 0, 0, 0, 1, 0, 0, 0, 1],
      [1, 1, 1, 1, 0, 1, 0, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 1, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 1, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 0, 1, 1, 1, 1, 1, 1],
      [1, 0, 0, 0, 1, 0, 0, 0, 0, 3],
      [1, 1, 1, 1, 1, 0, 1, 1, 1, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    ],
    // Seviye 6: Bol köşeli, açık alan yok
    [
      [2, 0, 1, 0, 0, 0, 0, 1, 0, 0],
      [1, 0, 1, 0, 1, 1, 0, 1, 1, 0],
      [0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
      [0, 1, 1, 1, 1, 0, 1, 1, 1, 1],
      [0, 0, 0, 0, 0, 0, 1, 0, 0, 0],
      [1, 1, 1, 0, 1, 1, 1, 0, 1, 0],
      [0, 0, 0, 0, 1, 0, 0, 0, 1, 0],
      [0, 1, 1, 1, 1, 0, 1, 1, 1, 0],
      [0, 0, 0, 1, 0, 0, 0, 0, 0, 0],
      [1, 1, 0, 1, 0, 1, 1, 1, 1, 3],
    ],
    // Seviye 7: Çift yön seçimi
    [
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [2, 0, 0, 1, 0, 0, 0, 0, 0, 1],
      [1, 1, 0, 1, 0, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 1, 0, 0, 0, 1],
      [1, 0, 1, 1, 1, 1, 0, 1, 1, 1],
      [1, 0, 0, 0, 0, 0, 0, 1, 0, 1],
      [1, 1, 1, 1, 1, 1, 0, 1, 0, 1],
      [1, 0, 0, 0, 0, 1, 0, 0, 0, 1],
      [1, 0, 1, 1, 0, 0, 0, 1, 3, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    ],

    // --- ZOR SEVİYELER (8-10) ---
    // Seviye 8: Ortadaki tuzağa dikkat
    [
      [2, 0, 1, 0, 0, 0, 1, 0, 0, 0],
      [0, 0, 1, 0, 1, 0, 1, 0, 1, 0],
      [1, 0, 0, 0, 1, 0, 0, 0, 1, 0],
      [0, 0, 1, 1, 1, 1, 1, 0, 1, 0],
      [0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 1, 0, 1, 1, 1, 1, 1, 1, 0],
      [0, 0, 0, 1, 3, 0, 0, 0, 1, 0], // Çıkış içeride bir yerde saklı
      [1, 1, 1, 1, 1, 1, 1, 0, 1, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 1, 0],
      [0, 1, 1, 1, 1, 1, 1, 1, 1, 0],
    ],
    // Seviye 9: Labirent içinde labirent (Sarmal yapı)
    [
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 2, 0, 0, 1, 0, 0, 0, 0, 1],
      [1, 0, 1, 0, 1, 0, 1, 1, 0, 1],
      [1, 0, 1, 0, 0, 0, 1, 0, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 0, 1, 1],
      [1, 0, 0, 0, 0, 0, 1, 0, 0, 1],
      [1, 1, 1, 1, 1, 0, 1, 1, 0, 1],
      [1, 0, 0, 0, 1, 0, 0, 1, 0, 1],
      [1, 0, 1, 0, 0, 0, 1, 1, 3, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    ],
    // Seviye 10: Satranç tahtası gibi, kör noktalar çok fazla
    [
      [2, 0, 1, 0, 0, 0, 1, 0, 0, 3],
      [0, 1, 1, 0, 1, 0, 1, 1, 0, 1],
      [0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
      [1, 1, 0, 1, 1, 1, 1, 0, 1, 1],
      [0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
      [0, 1, 1, 1, 0, 1, 0, 1, 1, 0],
      [0, 0, 0, 1, 0, 0, 0, 1, 0, 0],
      [1, 1, 0, 1, 1, 1, 0, 1, 0, 1],
      [0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
      [0, 1, 1, 1, 0, 0, 0, 1, 1, 0],
    ]
  ];

  MazeGameController() {
    resetGame();
  }

  // Sadece haritayı baştan başlatır (Bölüm değiştirmez, yandığında vs. kullanılır)
  void resetGame() {
    // Aktif olan indexteki haritayı çekip ekrana basıyoruz
    maze = _mazes[currentMazeIndex].map((row) => List<int>.from(row)).toList();
    isGameWon = false;
    _findPlayerStartPosition();
    notifyListeners();
  }

  // Sıradaki haritaya geçer
  void loadNextMaze() {
    // Index'i 1 artır. Eğer toplam harita sayısına ulaşırsa başa (0'a) sar.
    currentMazeIndex = (currentMazeIndex + 1) % _mazes.length;
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