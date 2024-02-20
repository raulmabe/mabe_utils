import 'package:flutter/widgets.dart';

/// Allows to wrap any stateless widget that needs to execute a one time
/// command on init.
class OnInitWrapper extends StatefulWidget {
  /// Allows to wrap any stateless widget that needs to execute a one time
  /// command on init.
  const OnInitWrapper({
    required this.onInit,
    required this.child,
    super.key,
  });

  /// Widget child
  final Widget child;

  /// Callback called on initState.
  final VoidCallback onInit;

  @override
  State<OnInitWrapper> createState() => _OnInitWrapperState();
}

class _OnInitWrapperState extends State<OnInitWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onInit();
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
