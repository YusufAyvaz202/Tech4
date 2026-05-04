import 'package:flutter/material.dart';

class MazeGridBoard extends StatelessWidget {
  final List<List<int>> maze;

  const MazeGridBoard({Key? key, required this.maze}) : super(key: key);

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

            Color cellColor;
            if (cellValue == 1) {
              cellColor = Colors.black87;
            } else if (cellValue == 2) {
              cellColor = Colors.green; 
            } else if (cellValue == 3) {
              cellColor = Colors.red; 
            } else {
              cellColor = Colors.white;
            }

            return Container(
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