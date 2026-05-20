// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/game_provider.dart';
import '../models/sudoku_cell.dart';

class CellWidget extends StatelessWidget {
  final int row;
  final int col;

  const CellWidget({super.key, required this.row, required this.col});

  @override
  Widget build(BuildContext context) {
    // Listen to changes for this specific cell through the provider.
    final gameProvider = context.watch<GameProvider>();
    final cell = gameProvider.board!.grid[row][col];

    return GestureDetector(
      onTap: () => gameProvider.selectCell(row, col),
      child: Container(
        decoration: BoxDecoration(
          color: _getBackgroundColor(cell),
          border: _getBorder(row, col),
        ),
        child: Center(
          child: Text(
            cell.value == null ? '' : cell.value.toString(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: cell.isFixed ? FontWeight.bold : FontWeight.normal,
              color: _getTextColor(cell),
            ),
          ),
        ),
      ),
    );
  }

  // Determines background color based on selection and error state.
  Color _getBackgroundColor(SudokuCell cell) {
    // Check the error state first. 
    // If the move is invalid, show a red background immediately.
    if (cell.isWrong) {
      // If the cell is both wrong and currently selected, make it a bit darker red
      // so the user still knows it is active.
      return cell.isSelected ? Colors.red.withOpacity(0.4) : Colors.red.withOpacity(0.2);
    }
    
    // If there is no error, check if the cell is selected.
    if (cell.isSelected) {
      return Colors.blue.withOpacity(0.3);
    }
    
    // Default background color for empty or correctly filled unselected cells.
    return Colors.white;
  }

  // Determines text color: Black for fixed, Blue for user input, Red for errors.
  Color _getTextColor(SudokuCell cell) {
    if (cell.isWrong) return Colors.red;
    if (cell.isFixed) return Colors.black;
    return Colors.blue.shade800;
  }

  // Creates the borders. Thicker borders for 3x3 box boundaries.
  Border _getBorder(int row, int col) {
    return Border(
      top: BorderSide(width: (row % 3 == 0) ? 2.0 : 0.5, color: Colors.black),
      left: BorderSide(width: (col % 3 == 0) ? 2.0 : 0.5, color: Colors.black),
      bottom: BorderSide(width: (row == 8) ? 2.0 : 0.5, color: Colors.black),
      right: BorderSide(width: (col == 8) ? 2.0 : 0.5, color: Colors.black),
    );
  }
}