import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mabe_utils/mabe_utils.dart';

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
  final Widget Function(BuildContext context, bool isLoading, StringMap tasks) loadingOverlay;

  /// Returns the closest [LoaderManagerState] up in the widget tree.
  static LoaderManagerState of(BuildContext context) => context.findAncestorStateOfType<LoaderManagerState>()!;

  @override
  State<LoaderManager> createState() => LoaderManagerState();
}

/// [LoaderManager] state
class LoaderManagerState extends State<LoaderManager> {
  late StringMap _loadingTasks;
  late final ValueNotifier<bool> _rebuildManager;

  @override
  void initState() {
    super.initState();
    _rebuildManager = ValueNotifier(false);
    _loadingTasks = {};
  }

  bool get _isLoading => _loadingTasks.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ValueListenableBuilder(
          valueListenable: _rebuildManager,
          builder: (context, _, child) => IgnorePointer(
            ignoring: _isLoading,
            child: child,
          ),
          child: widget.child,
        ),
        Positioned.fill(
          child: ValueListenableBuilder(
            valueListenable: _rebuildManager,
            builder: (context, _, child) => IgnorePointer(
              ignoring: !_isLoading,
              child: widget.loadingOverlay(context, _isLoading, _loadingTasks),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _rebuildManager.dispose();
    super.dispose();
  }

  /// Adds an overlay while this task is being executed.
  void showLoading({required String tag, String? message}) {
    _loadingTasks.putIfAbsent(tag, () => message ?? 'Loading...');
    assert(_loadingTasks.containsKey(tag), 'The task $tag was already loading');
    log('LoaderManager: $tag added');
    _rebuild();
  }

  /// Removes the tasks, and subsequently the loading overlay.
  Future<void> hideLoading({required String tag}) async {
    final modified = _loadingTasks.remove(tag);
    assert(modified != null, 'The task $tag was not loading');
    log('LoaderManager: $tag removed');
    _rebuild();
  }

  void _rebuild() => _rebuildManager.value = !_rebuildManager.value;
}
