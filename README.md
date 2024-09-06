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
