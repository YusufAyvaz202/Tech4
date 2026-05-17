import 'package:flutter/material.dart';

class MazeGridBoard extends StatelessWidget {
  final List<List<int>> maze;
  final List<List<int>> hintPath; 

  const MazeGridBoard({
    Key? key, 
    required this.maze,
    required this.hintPath, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1, 
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
              cellColor = Colors.black87;
            } else if (cellValue == 2) {
              cellColor = Colors.green; 
            } else if (cellValue == 3) {
              cellColor = Colors.red; 
            } else if (isHint) {
              cellColor = Colors.amber.shade300; 
            } else {
              cellColor = Colors.white;
            }

            // Kayan animasyon için AnimatedContainer kullanıyoruz
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300), // Renk değişim süresi
              curve: Curves.easeInOut, // Animasyonun yumuşaklık eğrisi
              margin: const EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                color: cellColor,
                border: Border.all(color: Colors.grey.shade300, width: 0.5),
                borderRadius: cellValue == 2 ? BorderRadius.circular(4.0) : BorderRadius.zero,
              ),
            );
          },
        ),
      ),
    );
  }
}