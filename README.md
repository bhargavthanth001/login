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

class AnimatedContainerMovingDown extends StatefulWidget {
  @override
  _AnimatedContainerMovingDownState createState() => _AnimatedContainerMovingDownState();
}

class _AnimatedContainerMovingDownState extends State<AnimatedContainerMovingDown> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: MovingDown(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Container(
        height: 50,
        width: 50,
        color: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class MovingDown extends Curve {
  @override
  double transformInternal(double t) {
    debugPrint("$t");
    return 0.5 + math.sin(t * 2 * math.pi) * 0.5;
  }
}