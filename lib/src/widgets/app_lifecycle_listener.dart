import 'package:flutter/material.dart';

/// Widget that exposes callbacks for each life cycle of a Flutter App.
class AppLifeCycleListener extends StatefulWidget {
  /// Widget that exposes callbacks for each life cycle of a Flutter App.
  const AppLifeCycleListener({
    required this.child,
    super.key,
    this.onResumed,
    this.onPaused,
    this.onInactive,
    this.onDetached,
  });

  /// Callback executed when the app is resumed
  final VoidCallback? onResumed;

  /// Callback executed when the app is paused
  final VoidCallback? onPaused;

  /// Callback executed when the app is inactive
  final VoidCallback? onInactive;

  /// Callback executed when the app is detached
  final VoidCallback? onDetached;

  /// Child
  final Widget child;

  @override
  State<AppLifeCycleListener> createState() => _AppLifeCycleListenerState();
}

/// State
class _AppLifeCycleListenerState extends State<AppLifeCycleListener>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        widget.onResumed?.call();
      case AppLifecycleState.inactive:
        widget.onInactive?.call();
      case AppLifecycleState.paused:
        widget.onPaused?.call();
      case AppLifecycleState.detached:
        widget.onDetached?.call();
      case _:
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
