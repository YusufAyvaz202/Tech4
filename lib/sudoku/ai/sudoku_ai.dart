import '../models/sudoku_board.dart';

class SudokuAI {
  static List<List<int>>? getSolution(SudokuBoard currentBoard) {
    List<List<int>> solveGrid = List.generate(9, (r) => List.generate(9, (c) {
      var cell = currentBoard.grid[r][c];
      return cell.isFixed ? cell.value! : 0;
    }));

    if (_solve(solveGrid)) {
      return solveGrid;
    }
    return null;
  }

  static bool _solve(List<List<int>> grid) {
    int row = -1;
    int col = -1;
    bool isEmptyCellFound = false;

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

    if (!isEmptyCellFound) return true;

    for (int num = 1; num <= 9; num++) {
      if (_isValidForSolver(grid, row, col, num)) {
        grid[row][col] = num;
        if (_solve(grid)) return true;
        grid[row][col] = 0;
      }
    }
    return false;
  }

  static bool _isValidForSolver(List<List<int>> grid, int row, int col, int value) {
    for (int c = 0; c < 9; c++) {
      if (grid[row][c] == value) return false;
    }
    for (int r = 0; r < 9; r++) {
      if (grid[r][col] == value) return false;
    }
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