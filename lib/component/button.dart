import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/model/model.dart';

class CustomAnimatedOpacityButton extends HookConsumerWidget {
  const CustomAnimatedOpacityButton({
    super.key,
    required this.onTap,
    required this.child,
    this.opacity,
  });
  final Widget child;
  final VoidCallback? onTap;
  final double? opacity;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTapEvent = useState<bool>(false);
    return GestureDetector(
      onTap: onTap != null
          ? () {
              isTapEvent.value = false;
              onTap?.call();
            }
          : null,
      onTapDown: onTap != null ? (_) => isTapEvent.value = true : null,
      onTapCancel: onTap != null ? () => isTapEvent.value = false : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: isTapEvent.value ? opacity ?? 0.6 : 1,
        child: child,
      ),
    );
  }
}

Widget mainButton(
  BuildContext context, {
  required String text,
  required VoidCallback? onTap,
  Color backGroundColor = Colors.white,
  Color textColor = Colors.black,
  double? height,
  double? width,
  double? fontSize,
  double radius = 15,
  List<BoxShadow>? boxShadow,
  Color? borderColor,
  AlignmentGeometry alignment = Alignment.center,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return CustomAnimatedOpacityButton(
    onTap: onTap,
    child: Container(
      alignment: alignment,
      height: height ?? safeAreaHeight * 0.065,
      width: width ?? safeAreaWidth,
      decoration: BoxDecoration(
        color: backGroundColor,
        border: borderColor != null ? Border.all(color: borderColor) : null,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: boxShadow,
      ),
      child: nText(
        text,
        color: textColor,
        fontSize: fontSize ?? safeAreaWidth / 28,
      ),
    ),
  );
}

Widget iconButtonWithCancel(
  BuildContext context, {
  required double size,
  BackIconStyleType iconType = BackIconStyleType.cancelIcon,
  VoidCallback? customOnTap,
  List<Shadow>? shadows,
}) {
  IconData icon() {
    switch (iconType) {
      case BackIconStyleType.cancelIcon:
        return Icons.close;
      case BackIconStyleType.arrowBackLeftIcon:
        return Icons.arrow_back;
      case BackIconStyleType.arrowBackBottomIcon:
        return Icons.keyboard_arrow_down;
    }
  }

  return CustomAnimatedOpacityButton(
    onTap: customOnTap ?? () => Navigator.pop(context),
    child: Icon(
      size: size,
      icon(),
      color: Colors.white,
      shadows: shadows,
    ),
  );
}
