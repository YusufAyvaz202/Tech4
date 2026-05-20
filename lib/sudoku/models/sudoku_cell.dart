class SudokuCell {
  // The actual value of the cell (1-9). Null means the cell is empty.
  int? value;
  
  // Indicates if this number was provided by the initial puzzle.
  // Fixed cells cannot be modified or erased by the user.
  final bool isFixed;
  
  // Indicates if the user has currently tapped on this cell.
  bool isSelected;
  
  // Indicates if the user entered a wrong number (conflicts with rules).
  // We will use this to show the red warning color on the UI.
  bool isWrong;

  SudokuCell({
    this.value,
    this.isFixed = false,
    this.isSelected = false,
    this.isWrong = false,
  });

  // A helper method to create a copy of the cell if needed for state updates.
  SudokuCell copyWith({
    int? value,
    bool? isFixed,
    bool? isSelected,
    bool? isWrong,
  }) {
    return SudokuCell(
      value: value ?? this.value,
      isFixed: isFixed ?? this.isFixed,
      isSelected: isSelected ?? this.isSelected,
      isWrong: isWrong ?? this.isWrong,
    );
  }
}