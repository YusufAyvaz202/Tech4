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
    // Listen to changes for this specific cell through the provider
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
              fontWeight: cell.isFixed ? FontWeight.bold : FontWeight.w500,
              color: _getTextColor(cell),
            ),
          ),
        ),
      ),
    );
  }

  // Determines background color based on selection and error state
  Color _getBackgroundColor(SudokuCell cell) {
    // Check the error state first
    // If the move is invalid, show a neon coral background
    if (cell.isWrong) {
      return cell.isSelected 
          ? const Color(0xFFFF6B6B).withOpacity(0.4) 
          : const Color(0xFFFF6B6B).withOpacity(0.2);
    }
    
    // If there is no error, check if the cell is selected
    if (cell.isSelected) {
      return const Color(0xFF94A3B8).withOpacity(0.3); // Slate Grey with opacity
    }
    
    // Default background color for empty or correctly filled unselected cells
    return const Color(0xFF1E2640); // Muted Charcoal
  }

  // Determines text color based on user input, fixed state or error
  Color _getTextColor(SudokuCell cell) {
    if (cell.isWrong) return const Color(0xFFFF6B6B); // Neon Coral
    if (cell.isFixed) return const Color(0xFFF8FAFC); // Off-White
    return const Color(0xFF00F5D4); // Electric Teal
  }

  // Creates the borders. Thicker Off-White borders for 3x3 block boundaries, thin Slate Grey for cells.
  Border _getBorder(int row, int col) {
    BorderSide getSide(bool isThick) {
      return BorderSide(
        width: isThick ? 2.0 : 0.5,
        color: isThick ? const Color(0xFFF8FAFC) : const Color(0xFF94A3B8), // Off-White vs Slate Grey
      );
    }

    return Border(
      top: getSide(row % 3 == 0),
      left: getSide(col % 3 == 0),
      bottom: getSide(row == 8),
      right: getSide(col == 8),
    );
  }
}