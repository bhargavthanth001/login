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

class HomeController extends GetxController {
  RxList<List<CellModel>> grid = RxList<List<CellModel>>();
  var groups = <GroupModel>[];

  final random = Random();

  final colors = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
  ];

  @override
  void onInit() {
    super.onInit();
    initializeGrid();
    compareCells();
  }

  initializeGrid() {
    grid.value = List.generate(
      15,
      (column) => List.generate(
        15,
        (row) {
          final color = colors[random.nextInt(colors.length)];
          return CellModel(
            id: getId(color),
            row: row,
            column: column,
            color: color,
          );
        },
      ),
    );
  }

  compareCells() {
    groups.clear();
    for (int row = 0; row < 15; row++) {
      for (int col = 0; col < 15; col++) {
        int id = random.nextInt(1000);
        List<CellModel> horizontalMatch = checkHorizontal(row, col);
        if (horizontalMatch.length >= 3) {
          GroupModel model = GroupModel(id: id, cells: horizontalMatch);
          groups.add(model);
        }
        List<CellModel> verticalMatch = checkVertical(row, col);
        if (verticalMatch.length >= 3) {
          GroupModel model = GroupModel(id: id, cells: verticalMatch);
          groups.add(model);
        }
      }
    }

    debugPrint(groups.length.toString());
    if (groups.isNotEmpty) {
      for (int i = 0; i < groups.length; i++) {
        removeMatchedCells(groups[i].cells);
      }
    } else {
      debugPrint("No Match Found...");
    }
  }

  List<CellModel> checkHorizontal(int row, int col) {
    List<CellModel> match = [];
    int initialId = grid[row][col].id;
    for (int i = row; i < 15; i++) {
      if (grid[i][col].id == initialId) {
        match.add(grid[i][col]);
      } else {
        break;
      }
    }
    return match;
  }

  List<CellModel> checkVertical(int row, int col) {
    List<CellModel> match = [];
    int initialId = grid[row][col].id;
    for (int i = col; i < 15; i++) {
      if (grid[row][i].id == initialId) {
        match.add(grid[row][i]);
      } else {
        break;
      }
    }
    return match;
  }

  removeMatchedCells(List<CellModel> cells) {
    for (int index = 0; index < cells.length; index++) {
      cells[index].id = 0;
      cells[index].color = Colors.transparent;
    }
    Timer(const Duration(milliseconds: 500), () async {
      await applyRemove(cells);
    });
  }

  applyRemove(List<CellModel> cells) {
    for (int col = 0; col < 15; col++) {
      for (int row = 14; row >= 0; row--) {
        if (grid[row][col].id == 0) {
          for (int aboveRow = row - 1; aboveRow >= 0; aboveRow--) {
            if (grid[aboveRow][col].id != 0) {
              var temp = grid[aboveRow][col];
              grid[aboveRow][col] = grid[row][col];
              grid[row][col] = temp;
            }
          }
        }
      }
    }
    grid.refresh();
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
    grid.refresh();
    Timer(const Duration(milliseconds: 500), () async {
      await compareCells();
    });
  }
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
        body: Obx(() {
          return GridView.count(
            crossAxisCount: 15,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            children: List.generate(15 * 15, (index) {
              int row = index ~/ 15;
              int column = index % 15;
              CellModel cell = controller.grid[row][column];

              return AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                top: cell.row * 40.0, // Assuming each cell height is 40
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: cell.color == Colors.transparent ? 0 : 1,
                  child: Container(
                    width: 40.0, // Assuming cell width is 40
                    height: 40.0,
                    color: cell.color,
                  ),
                ),
              );
            }),
          );
        }));
  }
}