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
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: BlastAnimationScreen(),
    );
  }
}

class BlastController extends GetxController with SingleGetTickerProviderMixin {
  AnimationController animationController;
  Animation<double> scaleAnimation;
  Animation<double> fadeAnimation;

  @override
  void onInit() {
    super.onInit();

    // Initialize the AnimationController with GetX's mixin
    animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    // Define a scaling animation (starts from 1.0 to 1.5, then fades)
    scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );

    // Define a fade animation (from visible to invisible)
    fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );

    // Start the animation as soon as the controller is initialized
    animationController.forward();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}

class BlastAnimationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize the BlastController
    final BlastController blastController = Get.put(BlastController());

    return Scaffold(
      appBar: AppBar(title: Text('Candy Crush Blast Animation with GetX')),
      body: Center(
        child: GetBuilder<BlastController>(
          builder: (_) {
            return AnimatedBuilder(
              animation: blastController.animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: blastController.fadeAnimation,
                  child: ScaleTransition(
                    scale: blastController.scaleAnimation,
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.red, // Color of the box
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}