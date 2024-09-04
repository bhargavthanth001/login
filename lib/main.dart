
import 'package:flutter/material.dart';
import 'Login.dart';

void main() {
  return runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Login(),
  ));
}



Future<void> applyGravity() async {
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
    await fillEmptyCells(col, emptyCellsCount); // Use `await` to ensure it's called sequentially
  }

  // Refresh the grid to update the UI
  grid.refresh();
}

Future<void> fillEmptyCells(int col, int emptyCellsCount) async {
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

  // Adding a delay to let UI update smoothly after each column
  await Future.delayed(const Duration(milliseconds: 100));
}

Future<void> processGroups() async {
  while (groups.isNotEmpty) {
    // Remove the matched cells
    removeMatchedCells(groups.removeAt(0).cells);

    // Apply gravity and refill the cells
    await applyGravity();

    // Let the UI update between processing each group
    await Future.delayed(const Duration(milliseconds: 300));
  }
}



