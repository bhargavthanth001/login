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

import 'dart:math';
import 'package:candy_crush_clone/app/data/model/cell_model.dart';
import 'package:candy_crush_clone/app/data/model/group_model.dart';
import 'package:candy_crush_clone/app/modules/home/data/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var groups = <GroupModel>[];
  int gridSize = 15;
  var grid = List<List<CellModel>>.generate(15, (i) => []);

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
  }

  initializeGrid() {
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        final color = colors[random.nextInt(colors.length)];
        grid[i].add(CellModel(id: getId(color), row: i, column: j, color: color));
      }
    }
  }

  compareCells() {
    groups.clear();
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
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
    processGroup();
  }

  processGroup() {
    while (groups.isNotEmpty) {
      removeMatchedCells(groups.removeAt(0).cells);
    }
  }

  List<CellModel> checkHorizontal(int row, int col) {
    List<CellModel> match = [];
    int initialId = grid[row][col].id;
    for (int i = col; i < gridSize; i++) {
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
    for (int i = row; i < gridSize; i++) {
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
      int row = cell.row;
      int col = cell.column;
      grid[row][col].id = 0;
      grid[row][col].color = Colors.transparent;
    }
    applyRemove(cells);
  }

  void applyRemove(List<CellModel> cells) {
    for (var cell in cells) {
      int col = cell.column;
      for (int row = cell.row; row > 0; row--) {
        grid[row][col] = grid[row - 1][col];
        grid[row][col].row = row;
      }
      // Fill the topmost row with new random cells
      grid[0][col] = CellModel(
        id: getId(colors[random.nextInt(colors.length)]),
        row: 0,
        column: col,
        color: colors[random.nextInt(colors.length)],
      );
    }
    compareCells();
  }
}