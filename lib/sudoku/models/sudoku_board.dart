import 'sudoku_cell.dart';

class SudokuBoard {
  // The 9x9 grid representing the Sudoku board.
  final List<List<SudokuCell>> grid;

  SudokuBoard({required this.grid});

  // Factory constructor to initialize a board from a 2D integer array (like from JSON).
  factory SudokuBoard.fromList(List<List<int>> values) {
    List<List<SudokuCell>> generatedGrid = [];

    for (int row = 0; row < 9; row++) {
      List<SudokuCell> rowCells = [];
      for (int col = 0; col < 9; col++) {
        int cellValue = values[row][col];
        // If the value is 0 in JSON, it means the cell is empty (null).
        // If it's not 0, it's a fixed initial number.
        rowCells.add(
          SudokuCell(
            value: cellValue == 0 ? null : cellValue,
            isFixed: cellValue != 0,
          ),
        );
      }
      generatedGrid.add(rowCells);
    }

    return SudokuBoard(grid: generatedGrid);
  }
}