import '../models/sudoku_board.dart';

class SudokuAI {
  // Returns the correct number for a specific cell using backtracking.
  // We solve a clean copy of the puzzle based ONLY on the fixed cells.
  // This prevents user-introduced errors from breaking the solver.
  static int? getHint(SudokuBoard currentBoard, int targetRow, int targetCol) {
    // 1. Create a 9x9 integer grid for the solver.
    // 0 represents an empty cell. We only copy 'isFixed' cells.
    List<List<int>> solveGrid = List.generate(9, (r) => List.generate(9, (c) {
      var cell = currentBoard.grid[r][c];
      return cell.isFixed ? cell.value! : 0;
    }));

    // 2. Solve the grid using backtracking.
    if (_solve(solveGrid)) {
      // 3. Return the correct value for the requested coordinates.
      return solveGrid[targetRow][targetCol];
    }

    // Returns null if the puzzle is unsolvable (shouldn't happen with valid JSON).
    return null;
  }

  // The core backtracking algorithm.
  // Returns true if a solution is found, false otherwise.
  static bool _solve(List<List<int>> grid) {
    int row = -1;
    int col = -1;
    bool isEmptyCellFound = false;

    // Find the next empty cell (represented by 0).
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (grid[r][c] == 0) {
          row = r;
          col = c;
          isEmptyCellFound = true;
          break;
        }
      }
      if (isEmptyCellFound) break;
    }

    // Base case: If there are no empty cells, the puzzle is solved.
    if (!isEmptyCellFound) {
      return true;
    }

    // Try placing numbers 1 through 9.
    for (int num = 1; num <= 9; num++) {
      if (_isValidForSolver(grid, row, col, num)) {
        // Place the number.
        grid[row][col] = num;

        // Recursively attempt to solve the rest of the board.
        if (_solve(grid)) {
          return true;
        }

        // Backtrack: Undo the placement and try the next number.
        grid[row][col] = 0;
      }
    }

    // Trigger backtracking if no number 1-9 is valid.
    return false;
  }

  // A lightweight validator specifically for the 2D int array used by the AI.
  static bool _isValidForSolver(List<List<int>> grid, int row, int col, int value) {
    // Check row
    for (int c = 0; c < 9; c++) {
      if (grid[row][c] == value) return false;
    }

    // Check column
    for (int r = 0; r < 9; r++) {
      if (grid[r][col] == value) return false;
    }

    // Check 3x3 sub-grid (box)
    int startRow = (row ~/ 3) * 3;
    int startCol = (col ~/ 3) * 3;
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        if (grid[startRow + r][startCol + c] == value) return false;
      }
    }

    return true;
  }
}