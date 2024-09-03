# login

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

removeMatchedCells(List<CellModel> cells) {
  debugPrint("Cell Length => ${cells.length}");
  
  // Mark cells as empty by setting id to 0
  for (int index = 0; index < cells.length; index++) {
    cells[index].id = 0; // empty cell
    cells[index].color = Colors.transparent; // represent empty visually
    debugPrint("Cell Row => ${cells[index].row}, Col => ${cells[index].column}");
  }

  applyGravity();
}

void applyGravity() {
  for (int col = 0; col < 15; col++) {
    // Start from the bottom row and go upwards
    for (int row = 14; row >= 0; row--) {
      if (grid[row][col].id == 0) {
        // Find the closest non-empty cell above
        for (int aboveRow = row - 1; aboveRow >= 0; aboveRow--) {
          if (grid[aboveRow][col].id != 0) {
            // Swap the current empty cell with the one above
            grid[row][col] = grid[aboveRow][col];
            grid[aboveRow][col] = CellModel(
              id: 0, // now this cell is empty
              row: aboveRow,
              column: col,
              color: Colors.transparent,
            );
            break;
          }
        }
      }
    }
  }

  // After gravity is applied, fill the empty cells at the top
  fillEmptyCells();
}

void fillEmptyCells() {
  for (int col = 0; col < 15; col++) {
    for (int row = 0; row < 15; row++) {
      if (grid[row][col].id == 0) {
        final color = colors[random.nextInt(colors.length)];
        grid[row][col] = CellModel(
          id: getId(color),
          row: row,
          column: col,
          color: color,
        );
      }
    }
  }

  // Update the view with the new grid
  grid.refresh();
}
