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
void applyGravity() {
  for (int col = 0; col < 15; col++) {
    int emptyCellsCount = 0; // Keep track of how many empty cells we have in each column

    // Start from the bottom row and go upwards
    for (int row = 14; row >= 0; row--) {
      if (grid[row][col].id == 0) {
        emptyCellsCount++; // Increment empty cell count if it's empty

        // Find the closest non-empty cell above
        for (int aboveRow = row - 1; aboveRow >= 0; aboveRow--) {
          if (grid[aboveRow][col].id != 0) {
            // Move the above cell down to the current empty spot
            grid[row][col] = grid[aboveRow][col];
            grid[aboveRow][col] = CellModel(
              id: 0, // Now this cell is empty
              row: aboveRow,
              column: col,
              color: Colors.transparent,
            );
            emptyCellsCount--; // Decrease empty count as we filled one
            break;
          }
        }
      }
    }

    // After gravity has been applied for this column, fill the remaining empty cells at the top
    fillEmptyCells(col, emptyCellsCount); // Pass the column and how many cells to fill
  }

  // Refresh the grid to update the UI
  grid.refresh();
}

void fillEmptyCells(int col, int emptyCellsCount) {
  // Only fill the top `emptyCellsCount` cells with random colors
  for (int row = 0; row < emptyCellsCount; row++) {
    final color = colors[random.nextInt(colors.length)];
    grid[row][col] = CellModel(
      id: getId(color),
      row: row,
      column: col,
      color: color, // Assign a random color to the empty cells
    );
  }
}
