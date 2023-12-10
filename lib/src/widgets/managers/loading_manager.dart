import 'dart:developer';

import 'package:flutter/material.dart';

/// Adds an overlay on top of all the subwidget tree when loading.
/// Allows to add loading tasks
class LoaderManager extends StatefulWidget {
  /// Adds an overlay on top of all the subwidget tree when loading.
  /// Allows to add loading tasks
  const LoaderManager({
    required this.child,
    required this.loadingOverlay,
    super.key,
  });

  /// Widget [child]
  final Widget child;

  /// Overlay builder
  final WidgetBuilder loadingOverlay;

  /// Returns the closest [LoaderManagerState] up in the widget tree.
  static LoaderManagerState of(BuildContext context) =>
      context.findAncestorStateOfType<LoaderManagerState>()!;

  @override
  State<LoaderManager> createState() => LoaderManagerState();
}

/// [LoaderManager] state
class LoaderManagerState extends State<LoaderManager> {
  late Map<String, String> _loadingTasks;

  @override
  void initState() {
    super.initState();
    _loadingTasks = {};
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _loadingTasks.isNotEmpty;
    return Stack(
      children: [
        IgnorePointer(
          ignoring: isLoading,
          child: widget.child,
        ),
        if (isLoading)
          Positioned.fill(
            child: IgnorePointer(
              ignoring: isLoading,
              child: widget.loadingOverlay(context),
            ),
          ),
      ],
    );
  }

  /// Adds an overlay while this task is being executed.
  void showLoading({required String tag, String? message}) {
    _loadingTasks.putIfAbsent(tag, () => message ?? 'Loading...');
    assert(_loadingTasks.containsKey(tag), 'The task $tag was already loading');
    log('LoaderManager: $tag added');
    setState(() {});
  }

  /// Removes the tasks, and subsequently the loading overlay.
  Future<void> hideLoading({required String tag}) async {
    final modified = _loadingTasks.remove(tag);
    assert(modified != null, 'The task $tag was not loading');
    log('LoaderManager: $tag removed');
    setState(() {});
  }
}
