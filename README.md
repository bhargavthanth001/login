import 'package:get/get.dart';

class AnimationControllerX extends GetxController with SingleGetTickerProviderMixin {
  late AnimationController _animationController;
  var isCollapsed = false.obs;

  @override
  void onInit() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    )..addListener(() {
        update();
      })..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // Animation completed
        }
      });
    super.onInit();
  }

  void toggleCollapse() {
    if (isCollapsed.value) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    isCollapsed.value = !isCollapsed.value;
  }

  @override
  void onClose() {
    _animationController.dispose();
    super.onClose();
  }

  Animation<double> get animation => _animationController;
  bool get collapseStatus => isCollapsed.value;
}


import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Grid Collapse Animation')),
        body: GridCollapseDemo(),
      ),
    );
  }
}

class GridCollapseDemo extends StatelessWidget {
  final AnimationControllerX controller = Get.put(AnimationControllerX());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              controller.toggleCollapse();
            },
            child: Obx(() => Text(controller.collapseStatus ? 'Expand' : 'Collapse')),
          ),
          SizedBox(height: 20),
          Obx(() {
            final scaleValue = controller.collapseStatus
                ? 1.0 - controller.animation.value
                : controller.animation.value;
            final size = 50.0; // Size of each grid item

            return Stack(
              children: List.generate(15 * 15, (index) {
                final int row = index ~/ 15;
                final int col = index % 15;
                final double x = col * size;
                final double y = row * size;

                // Calculate destination position for collapse animation
                final double destinationX = controller.collapseStatus ? 7 * size : x;
                final double destinationY = controller.collapseStatus ? 7 * size : y;

                return Positioned(
                  left: x + (controller.collapseStatus ? (1.0 - controller.animation.value) * (x - destinationX) : 0),
                  top: y + (controller.collapseStatus ? (1.0 - controller.animation.value) * (y - destinationY) : 0),
                  child: Transform.scale(
                    scale: controller.collapseStatus ? scaleValue : 1.0,
                    child: Container(
                      width: size,
                      height: size,
                      color: Colors.blue[(index % 9 + 1) * 100],
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }
}

