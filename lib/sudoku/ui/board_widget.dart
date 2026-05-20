import 'package:flutter/material.dart';
import 'cell_widget.dart';

class BoardWidget extends StatelessWidget {
  const BoardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0, // Ensures the board is a perfect square.
      child: Container(
        padding: const EdgeInsets.all(4.0),
        color: Colors.black, // Dark background for the main thick border
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(), // Disable scrolling inside the board
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 9,
          ),
          itemCount: 81,
          itemBuilder: (context, index) {
            int row = index ~/ 9;
            int col = index % 9;
            return CellWidget(row: row, col: col);
          },
        ),
      ),
    );
  }
}