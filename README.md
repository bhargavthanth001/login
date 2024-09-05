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

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Obx(
        () {
          return StaggeredGrid.count(
            crossAxisCount: 15,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            children: List.generate(
              15 * 15,
              (index) {
                int row = index ~/ 15;
                int column = index % 15;
                CellModel cell = controller.grid[row][column];
                return AnimatedCell(
                  cell: cell,
                  animated: controller.animatedCells.contains(cell),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class AnimatedCell extends StatelessWidget {
  final CellModel cell;
  final bool animated;

  AnimatedCell({required this.cell, required this.animated});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transform: animated
          ? Matrix4.translationValues(0, -50, 0) // Move the cell up
          : Matrix4.identity(),
      child: ColoredBox(
        color: cell.color,
      ),
    );
  }
}
final animatedCells = RxList<CellModel>();