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

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Moving Down Animation'),
        ),
        body: Center(
          child: AnimatedContainerMovingDown(),
        ),
      ),
    );
  }
}

class AnimatedContainerMovingDown extends (CurvedAnimation(
      parent: _controller,
      c







........
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

  final colors = [ 
    Colors.red, 
    Colors.blue, 
    Colors.yellow, 
    Colors.purple, 
  ]; 

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override 
  void onInit() { 
    super.onInit(); 
    initializeGrid(); 
    _animationController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );
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
    _animationController.forward().then((_) {
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
              grid[aboveRow][col] = grid[row][col]; 
              grid[row][col] = temp; 
              break; 
            } 
          } 
        } 
      } 
    } 
    grid.refresh(); 
    Future.delayed(animationDuration, () { 
      fillEmptyCells(); 
    }); 
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
    Future.delayed(delayedDuration, () { 
      compareCells(); 
    }); 
  } 
}



import 'package:flutter/material.dart'; 
import 'package:get/get.dart'; 

import '../../../data/model/cell_model.dart'; 
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
              )) 
        ], 
      ), 
      body: Obx( 
        () { 
          return GridView.builder( 
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 15, 
              mainAxisSpacing: 2, 
              crossAxisSpacing: 2,
            ), 
            itemCount: 15 * 15, 
            itemBuilder: (context, index) { 
              int row = index ~/ 15; 
              int column = index % 15; 
              CellModel cell = controller.grid[row][column]; 
              return AnimatedContainer( 
                duration: controller.animationDuration, 
                curve: Curves.easeOut, 
                color: cell.color, 
                child: cell.id == 0 ? SizedBox.shrink() : null, 
              ); 
            }, 
          ); 
        }, 
      ), 
    ); 
  } 
}
