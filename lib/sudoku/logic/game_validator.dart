import '../models/sudoku_cell.dart';

class GameValidator {
  // Checks if placing a 'value' at the given 'row' and 'col' is valid.
  static bool isValidMove({
    required List<List<SudokuCell>> grid,
    required int row,
    required int col,
    required int value,
  }) {
    // Check the row and the column for duplicates.
    for (int i = 0; i < 9; i++) {
      // Row check: skip the current column we are checking.
      if (i != col && grid[row][i].value == value) {
        return false;
      }
      // Column check: skip the current row we are checking.
      if (i != row && grid[i][col].value == value) {
        return false;
      }
    }

    // Check the 3x3 sub-grid (box) for duplicates.
    int startRow = (row ~/ 3) * 3;
    int startCol = (col ~/ 3) * 3;

    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        int currentRow = startRow + r;
        int currentCol = startCol + c;

        // Skip the exact cell we are checking.
        if (currentRow != row || currentCol != col) {
          if (grid[currentRow][currentCol].value == value) {
            return false;
          }
        }
      }
    }

    // If no conflicts were found, the move is valid.
    return true;
  }
}