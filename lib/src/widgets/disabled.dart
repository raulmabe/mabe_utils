import 'package:flutter/material.dart';
import 'package:mabe_utils/mabe_utils.dart';
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
    this.reason,
    this.isDisabled = true,
  });

  /// Dictates whether the [child] is currently in disabled state.
  final bool isDisabled;

  /// Widget [child]
  final Widget child;

  /// Callback fired when the child is tapped while disabled.
  final VoidContextCallback? onDisabledTapped;

  /// Reason to inform the user on why is this widget disabled. If not null,
  /// when tapping into a disabled widget it will show an alert
  /// through the closest ancestor of type [AlertManager]
  final String? reason;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: isDisabled ? SystemMouseCursors.forbidden : MouseCursor.defer,
      child: GestureDetector(
        onTap: isDisabled
            ? () {
                onDisabledTapped?.call(context);
                if (reason == null) return;
                final alertManager = AlertManager.maybeOf(context);
                alertManager?.alert(msg: reason!);
              }
            : null,
        child: AnimatedOpacity(
          opacity: isDisabled ? 0.5 : 1,
          duration: const Duration(milliseconds: 300),
          curve: Sprung.underDamped,
          child: AbsorbPointer(
            absorbing: isDisabled,
            child: child,
          ),
        ),
      ),
    );
  }
}
