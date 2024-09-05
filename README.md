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

class CellModel {
  int id;
  int row;
  int column;
  Color color;
  double top;

  CellModel({
    required this.id,
    required this.row,
    required this.column,
    required this.color,
    this.top = 0.0,  // New property for animation
  });
}



class HomeController extends GetxController with GetSingleTickerProviderStateMixin {
  // Rest of the controller code...

  var gridAnimationDuration = const Duration(milliseconds: 500); // Animation duration

  removeMatchedCells(List<CellModel> cells) {
    for (var cell in cells) {
      cell.id = 0; 
      cell.color = Colors.transparent;
    }

    // Delay for the removal animation
    Future.delayed(gridAnimationDuration, () {
      applyRemove(cells);
    });
  }

  applyRemove(List<CellModel> cells) {
    for (int col = 0; col < 15; col++) {
      for (int row = 14; row >= 0; row--) {
        if (grid[row][col].id == 0) {
          for (int aboveRow = row - 1; aboveRow >= 0; aboveRow--) {
            if (grid[aboveRow][col].id != 0) {
              var temp = grid[aboveRow][col];

              // Update position for the animation
              temp.top = (row - aboveRow) * 40.0;  // Adjust this for correct spacing

              grid[aboveRow][col] = grid[row][col];
              grid[row][col] = temp;
              break;
            }
          }
        }
      }
    }

    // Fill the empty cells after the animation completes
    Future.delayed(gridAnimationDuration, () {
      fillEmptyCells();
    });

    grid.refresh();
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
            top: 0.0,
          );
        }
      }
    }

    grid.refresh();
    compareCells();
  }

  // Rest of the controller code...
}





class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Obx(
        () {
          return Stack(
            children: [
              GridView.builder(
                itemCount: 15 * 15,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 15,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                itemBuilder: (context, index) {
                  int row = index ~/ 15;
                  int column = index % 15;
                  CellModel cell = controller.grid[row][column];

                  return AnimatedPositioned(
                    key: ValueKey(cell.id),
                    duration: controller.gridAnimationDuration,
                    top: cell.top,  // Use the top position for animation
                    child: AnimatedContainer(
                      duration: controller.gridAnimationDuration,
                      color: cell.color,
                      child: const SizedBox(width: 40, height: 40), // Adjust cell size here
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
