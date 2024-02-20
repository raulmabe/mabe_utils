import 'package:flutter/material.dart';
import 'package:mabe_utils/mabe_utils.dart';

enum PopupType {
  dialog,
  bottomSheet,
  page;
}

/// Mixin that tells the enum which methods it needs to override to be used with [InitialPopupsManager]
mixin InitialPopupMixin on Enum {
  /// Assigns the widget to this popup value.
  Widget build(BuildContext context);

  /// Callback fired when the popup assigned to this value is opened.
  void onOpen(BuildContext context);

  /// Callback fired when the popup assigned to this value is closed.
  void onClose(BuildContext context);

  /// Configures how InitialPopupsManager will open the corresponding popup.
  PopupType getType() => PopupType.dialog;
}

/// Initial popups has the logic to show all available popups once the app initializes or resumes.
class InitialPopupsManager<T extends InitialPopupMixin> extends StatefulWidget {
  /// Initial popups has the logic to show all available popups once the app initializes or resumes.
  const InitialPopupsManager({
    required this.availablePopups,
    required this.child,
    this.onResumeApp = true,
    this.onInit = true,
    this.onlyOnRoot = true,
    super.key,
  });

  /// List of all popups.
  final List<T> Function(BuildContext context, bool isOnResume) availablePopups;

  /// If true, it will show popup on app resumed.
  final bool onResumeApp;

  /// If true, it will show popup on init.
  final bool onInit;

  /// Child Widget.
  final Widget child;

  /// If true, this popups will only be showed on root page.
  final bool onlyOnRoot;

  @override
  State<InitialPopupsManager<T>> createState() => _InitialPopupsManagerState<T>();
}

class _InitialPopupsManagerState<T extends InitialPopupMixin> extends State<InitialPopupsManager<T>> {
  bool isCurrentlyShowing = false;

  @override
  Widget build(BuildContext context) {
    return AppLifeCycleListener(
      onResumed: () {
        if (widget.onResumeApp) {
          _showPopupIfNeeded(context, true);
        }
      },
      child: OnInitWrapper(
        onInit: () {
          if (widget.onInit) {
            _showPopupIfNeeded(context, false);
          }
        },
        child: widget.child,
      ),
    );
  }

  Future<void> _showPopupIfNeeded(BuildContext context, bool isOnResume) async {
    /// Check if manager is currently showing a popup already, and it's not closed yet.
    if (isCurrentlyShowing) return;

    /// Check if this route is root. If its not return.
    if (widget.onlyOnRoot && context.navigator.canPop()) return;

    final values = widget.availablePopups(context, isOnResume);
    if (values.isEmpty) return;

    for (final value in values) {
      if (!context.mounted) continue;
      value.onOpen(context);
      isCurrentlyShowing = true;

      final type = value.getType();

      switch (type) {
        case PopupType.dialog:
          await showDialog<void>(
            context: context,
            builder: value.build,
          );
        case PopupType.bottomSheet:
          // ignore: use_build_context_synchronously
          await context.bottomsheetBuilder<void>(value.build);
        case PopupType.page:
          // ignore: use_build_context_synchronously
          await context.navigator.push(MaterialPageRoute<void>(builder: value.build));
      }

      isCurrentlyShowing = false;
      if (!context.mounted) continue;
      value.onClose(context);
    }
  }
}
