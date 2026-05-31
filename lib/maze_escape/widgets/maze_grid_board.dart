import 'package:flutter/material.dart';

class MazeGridBoard extends StatelessWidget {
  final List<List<int>> maze;
  final List<List<int>> hintPath; 

  const MazeGridBoard({
    super.key, 
    required this.maze,
    required this.hintPath, 
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1, 
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // Tahtanın dış çerçevesi
          decoration: BoxDecoration(
            color: const Color(0xFF1E2640), // Zemin: Muted Charcoal
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF3A4454), width: 2), // Çerçeve: Cool Grey
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(4.0),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: maze[0].length, 
            ),
            itemCount: maze.length * maze[0].length, 
            itemBuilder: (context, index) {
              int row = index ~/ maze[0].length;
              int col = index % maze[0].length;
              int cellValue = maze[row][col];

              bool isHint = hintPath.any((pos) => pos[0] == row && pos[1] == col);

              Color cellColor;
              if (cellValue == 1) {
                cellColor = const Color(0xFF3A4454); // Duvar: Cool Grey
              } else if (cellValue == 2) {
                cellColor = const Color(0xFF00F5D4); // Oyuncu: Electric Teal
              } else if (cellValue == 3) {
                cellColor = const Color(0xFFFF6B6B); // Hedef: Neon Coral
              } else if (isHint) {
                cellColor = const Color(0xFF94A3B8); // İpucu Yolu: Slate Grey
              } else {
                cellColor = const Color(0xFF121826); // Boş Yol: Deep Slate
              }

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300), 
                curve: Curves.easeInOut, 
                margin: const EdgeInsets.all(1.0),
                decoration: BoxDecoration(
                  color: cellColor,
                  borderRadius: cellValue == 2 || cellValue == 3 
                      ? BorderRadius.circular(6.0) 
                      : BorderRadius.circular(2.0), // Karelere hafif yuvarlaklık
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}