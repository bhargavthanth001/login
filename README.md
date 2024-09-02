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


compareCells() {
  // Reset groups
  group.clear();
  
  // Iterate through the grid
  for (int row = 0; row < 15; row++) {
    for (int col = 0; col < 15; col++) {
      // Check horizontal matches
      List<CellModel> horizontalMatch = _checkHorizontal(row, col);
      if (horizontalMatch.length >= 3) {
        group.addAll(horizontalMatch);
      }

      // Check vertical matches
      List<CellModel> verticalMatch = _checkVertical(row, col);
      if (verticalMatch.length >= 3) {
        group.addAll(verticalMatch);
      }
    }
  }
  
  // Remove the matched cells (for now replace them with a new random color)
  _removeMatchedCells();
  
  debugPrint("Total Matched Group Size => ${group.length}");
}

// Check horizontal matches starting from (row, col)
List<CellModel> _checkHorizontal(int row, int col) {
  List<CellModel> match = [];
  int initialId = grid[row][col].id;

  for (int i = col; i < 15; i++) {
    if (grid[row][i].id == initialId) {
      match.add(grid[row][i]);
    } else {
      break;  // Stop matching if we find a different block
    }
  }

  return match;
}

// Check vertical matches starting from (row, col)
List<CellModel> _checkVertical(int row, int col) {
  List<CellModel> match = [];
  int initialId = grid[row][col].id;

  for (int i = row; i < 15; i++) {
    if (grid[i][col].id == initialId) {
      match.add(grid[i][col]);
    } else {
      break;  // Stop matching if we find a different block
    }
  }

  return match;
}

// Replace matched cells with new random colors
_removeMatchedCells() {
  for (var cell in group) {
    final color = colors[random.nextInt(colors.length)];
    cell.id = getId(color);  // Update the id with the new color
    cell.color = color;  // Change the color of the matched cell
  }
  group.clear();  // Clear group after updating
}