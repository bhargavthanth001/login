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

applyRemove(List<CellModel> cells) {
  for (int col = 0; col < 15; col++) {
    // Start from the bottom row and move upwards
    for (int row = 14; row >= 0; row--) {
      if (grid[row][col].id == 0) {
        // Find the nearest non-empty cell above the current empty one
        for (int aboveRow = row - 1; aboveRow >= 0; aboveRow--) {
          if (grid[aboveRow][col].id != 0) {
            // Swap the empty cell with the above non-empty cell
            var temp = grid[aboveRow][col];
            grid[aboveRow][col] = grid[row][col];
            grid[row][col] = temp;
            break; // Once the swap is done, break out of the inner loop
          }
        }
      }
    }
  }

  // Now, fill any remaining empty cells with new random ones
  fillEmptyCells();
}

void fillEmptyCells() {
  for (int col = 0; col < 15; col++) {
    for (int row = 0; row < 15; row++) {
      if (grid[row][col].id == 0) {
        // Create a new random cell to fill the empty space
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

  grid.refresh();

  // After filling the empty cells, check for new matches
  Timer(const Duration(seconds: 5), () async {
    await compareCells();
  });
}