import 'package:flutter/material.dart';

/// Calls `FocusManager.instance.primaryFocus?.unfocus()` when tapped.
class UnfocusOnTap extends StatelessWidget {
  /// Calls `FocusManager.instance.primaryFocus?.unfocus()` when tapped.
  const UnfocusOnTap({required this.behavior, required this.child, super.key});

  /// Specify the HitTestBehavior of the tap
  final HitTestBehavior behavior;

  /// Widghet child
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: behavior,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}
