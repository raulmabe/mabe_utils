import 'package:flutter/material.dart';
import 'package:mabe_utils/src/extensions/extensions.dart';
import 'package:mabe_utils/src/types/types.dart';
import 'package:mabe_utils/src/widgets/managers/alert_manager.dart';
import 'package:mabe_utils/src/widgets/managers/loading_manager.dart';
import 'package:mabe_utils/src/widgets/providers/keyboard_height_provider.dart';

/// Common extensions for BuildContext
extension BuildContextExt on BuildContext {
  /// Equivalent as `Navigator.of(context)`
  NavigatorState get navigator => Navigator.of(this);

  /// Equivalent as `MediaQuery.sizeOf(context)`
  Size get screen => MediaQuery.sizeOf(this);

  /// Equivalent as `MediaQuery.of(context)`
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Returns padding for the nearest MediaQuery ancestor or
  /// throws an exception, if no such ancestor exists.
  EdgeInsets get padding => MediaQuery.paddingOf(this);

  /// Equivalent as `Theme.of(context)`
  ThemeData get theme => Theme.of(this);

  /// Returns the current [LayoutBreakpoint] based on screen device size.
  LayoutBreakpoint get breakpoint {
    final width = screen.width;
    if (width < LayoutBreakpoint.mobile.value) return LayoutBreakpoint.mobile;
    if (width < LayoutBreakpoint.tablet.value) return LayoutBreakpoint.tablet;
    return LayoutBreakpoint.desktop;
  }

  /// Returns `true` if screen device size is [LayoutBreakpoint.mobile]
  bool get isMobile => breakpoint == LayoutBreakpoint.mobile;

  /// Returns `true` if screen device size is [LayoutBreakpoint.tablet]
  bool get isTablet => breakpoint == LayoutBreakpoint.tablet;

  /// Returns `true` if screen device size is [LayoutBreakpoint.desktop]
  bool get isDesktop => breakpoint == LayoutBreakpoint.desktop;

  /// Returns a ValueNotifier that fires everytime
  /// the **max** keyboard height changes.
  ValueNotifier<double> get maxKeyboardHeight =>
      KeyboardHeightProvider.of(this).maxKeyboardHeight;

  /// Returns a ValueNotifier that fires everytime the keyboard height changes.
  ValueNotifier<double> get keyboardHeight =>
      KeyboardHeightProvider.of(this).keyboardHeight;

  /// Returns the closest [KeyboardHeightProvider] to the tree if any,
  KeyboardHeightProviderState? get maybeKeyboardHeightProvider =>
      KeyboardHeightProvider.maybeOf(this);

  // * Managers
  /// Adds an overlay while this task is being executed.
  void showLoading({required String tag, String? message}) =>
      LoaderManager.of(this).showLoading(tag: tag, message: message);

  /// Removes the tasks, and subsequently the loading overlay.
  void hideLoading({required String tag}) =>
      LoaderManager.of(this).hideLoading(tag: tag);

  /// Adds a new alert.
  void alert({
    required String msg,
    AlertType? type,
    String? id,
    Duration? duration,
  }) =>
      AlertManager.of(this)
          .alert(msg: msg, type: type, id: id, duration: duration);

  /// It shows a Dialog and will the corresponding [AppDialogAction].
  Future<AppDialogAction> popup(
    Widget dialog, {
    Color? barrierColor,
    bool? isDismissable,
  }) async {
    final resp = await showDialog<AppDialogAction?>(
      context: this,
      builder: (context) => dialog,
      barrierColor: barrierColor,
      barrierDismissible: isDismissable ?? true,
    );
    return resp ?? AppDialogAction.cancel;
  }

  // Future<T?> bottomsheetBuilder<T>(WidgetBuilder builder) {
  //   return showCupertinoModalBottomSheet<T?>(
  //     context: this,
  //     builder: builder,
  //     useRootNavigator: true,
  //   );
  // }

  // Future<T?> bottomsheet<T>(Widget child) {
  //   return showCupertinoModalBottomSheet<T?>(
  //     context: this,
  //     builder: (context) => Padding(
  //       padding: const EdgeInsets.only(top: 20),
  //       child: child,
  //     ),
  //     elevation: 0,
  //     useRootNavigator: true,
  //     clipBehavior: Clip.none,
  //     shadow: const BoxShadow(color: Colors.transparent),
  //     barrierColor: appTheme.background.withOpacity(.9),
  //     backgroundColor: Colors.transparent,
  //   );
  // }
}
