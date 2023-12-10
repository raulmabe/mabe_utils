import 'package:flutter/material.dart';
import 'package:mabe_utils/src/types/types.dart';
import 'package:sprung/sprung.dart';

/// Marks [child] as disabled by reducing its opacity to half and ignoring
/// pointers.
class Disabled extends StatelessWidget {
  /// Marks [child] as disabled by reducing its opacity to half and ignoring
  /// pointers.
  const Disabled({
    required this.child,
    super.key,
    this.onDisabledTapped,
    this.isDisabled = true,
  });

  /// Dictates whether the [child] is currently in disabled state.
  final bool isDisabled;

  /// Widget [child]
  final Widget child;

  /// Callback fired when the child is tapped while disabled.
  final VoidContextCallback? onDisabledTapped;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? () => onDisabledTapped?.call(context) : null,
      child: AnimatedOpacity(
        opacity: isDisabled ? 0.5 : 1,
        duration: const Duration(milliseconds: 300),
        curve: Sprung.underDamped,
        child: AbsorbPointer(
          absorbing: isDisabled,
          child: child,
        ),
      ),
    );
  }
}
