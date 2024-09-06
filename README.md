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

class AnimationComboCollapse extends StatefulWidget {
  AnimationComboCollapse({
    Key? key,
    required this.combo,
    required this.resultingTile,
    required this.onComplete,
  }) : super(key: key);

  final Combo combo;
  final VoidCallback onComplete;
  final Tile resultingTile;

  @override
  _AnimationComboCollapseState createState() => _AnimationComboCollapseState();
}

class _AnimationComboCollapseState extends State<AnimationComboCollapse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              widget.onComplete();
                        }
          });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double destinationX = widget.resultingTile.x!;
    final double destinationY = widget.resultingTile.y!;

    // Tiles are collapsing at the position of the resulting tile
    List<Widget> children = widget.combo.tiles.map((Tile tile) {
      return Positioned(
        left: tile.x! + (1.0 - _controller.value) * (tile.x! - destinationX),
        top: tile.y! + (1.0 - _controller.value) * (destinationY - tile.y!),
        child: Transform.scale(
          scale: 1.0 - _controller.value,
          child: tile.widget,
        ),
      );
    }).toList();

    // Display the resulting tile
    children.add(
      Positioned(
        left: destinationX,
        top: destinationY,
        child: Transform.scale(
          scale: _controller.value,
          child: widget.resultingTile.widget,
        ),
      ),
    );
    return Stack(
      children: children,
    );
  }
}
