RangeError (length): Invalid value: Valid value range is empty: 0
A RenderFlex overflowed by 99201 pixels on the bottom.

RangeError (length): Invalid value: Valid value range is empty: 0


Errors on this code :
import 'package:candy_crush_clone/app/data/model/cell_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: controller.initializeGrid,
            icon: const Icon(
              Icons.restart_alt,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                controller.toggleCollapse();
              },
              child: Obx(() =>
                  Text(controller.isCollapsed.value ? 'Expand' : 'Collapse')),
            ),
            const SizedBox(height: 20),
            Obx(
              () {
                final scaleValue = controller.isCollapsed.value
                    ? 1.0 - controller.animationController.value
                    : controller.animationController.value;
                const size = 40.0;
                return Stack(
                  children: List.generate(
                    15 * 15,
                    (index) {
                      final int row = index ~/ 15;
                      final int col = index % 15;
                      final double x = col * size;
                      final double y = row * size;
                      final double destinationX =
                          controller.isCollapsed.value ? 7 * size : x;
                      final double destinationY =
                          controller.isCollapsed.value ? 7 * size : y;
                      CellModel cell = controller.grid[row][col];
                      return Positioned(
                        left: x +
                            (controller.isCollapsed.value
                                ? (1.0 - controller.animationController.value) *
                                    (x - destinationX)
                                : 0),
                        top: y +
                            (controller.isCollapsed.value
                                ? (1.0 - controller.animationController.value) *
                                    (y - destinationY)
                                : 0),
                        child: Transform.scale(
                          scale:
                              controller.isCollapsed.value ? scaleValue : 1.0,
                          child: ColoredBox(color: cell.color),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
import 'dart:async';
import 'dart:math';

import 'package:candy_crush_clone/app/data/model/cell_model.dart';
import 'package:candy_crush_clone/app/data/model/group_model.dart';
import 'package:candy_crush_clone/app/modules/home/data/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxList<List<CellModel>> grid = RxList<List<CellModel>>();
  var groups = <GroupModel>[];
  var show = true.obs;
  var delayedDuration = const Duration(seconds: 3);
  var animationDuration = const Duration(milliseconds: 900);
  final random = Random();
  RxDouble scale = 1.0.obs;

  final colors = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
  ];

  late AnimationController animationController;
  var isCollapsed = false.obs;

  @override
  void onInit() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )
      ..addListener(() {
        update();
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // Animation completed
        }
      });

    super.onInit();
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
    Future.delayed(delayedDuration, () {
      compareCells();
    });
  }

  void toggleCollapse() {
    if (isCollapsed.value) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
    isCollapsed.value = !isCollapsed.value;
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

    if (groups.isNotEmpty) {
      for (int i = 0; i < groups.length; i++) {
        removeMatchedCells(groups[i].cells);
      }
    }
  }

  List<CellModel> checkHorizontal(int row, int col) {
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

  List<CellModel> checkVertical(int row, int col) {
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

  removeMatchedCells(List<CellModel> cells) {
    for (var cell in cells) {
      cell.id = 0;
      cell.color = Colors.transparent;
    }
    // _animationController.forward().then((_) {
    applyRemove(cells);
    // });
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
              break;
            }
          }
        }
      }
    }
    // Future.delayed(const Duration(milliseconds: 1300), () {
    // fillEmptyCells();
    refreshGrid();
    // });
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
    refreshGrid();
    Future.delayed(delayedDuration, () {
      compareCells();
    });
  }

  refreshGrid() {
    grid.refresh();
  }
}
