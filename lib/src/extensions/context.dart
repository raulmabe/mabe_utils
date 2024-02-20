import 'package:flutter/material.dart';
import 'package:mabe_utils/mabe_utils.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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

  /// Returns viewInsets for the nearest MediaQuery ancestor or
  /// throws an exception, if no such ancestor exists.
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  /// Equivalent as `Theme.of(context)`
  ThemeData get theme => Theme.of(this);

  /// Returns the current [LayoutBreakpoint] based on screen device size.
  LayoutBreakpoint get breakpoint {
    final width = screen.width;
    if (width < LayoutBreakpoint.smallMobile.value) return LayoutBreakpoint.smallMobile;
    if (width < LayoutBreakpoint.mobile.value) return LayoutBreakpoint.mobile;
    if (width < LayoutBreakpoint.tablet.value) return LayoutBreakpoint.tablet;
    return LayoutBreakpoint.desktop;
  }

  /// Returns `true` if screen device size is [LayoutBreakpoint.smallMobile]
  bool get isSmallMobile => breakpoint == LayoutBreakpoint.smallMobile;

  /// Returns `true` if screen device size is [LayoutBreakpoint.mobile]
  bool get isBigMobile => breakpoint == LayoutBreakpoint.mobile;

  /// Returns `true` if screen device size is [LayoutBreakpoint.mobile] or [LayoutBreakpoint.smallMobile]
  bool get isMobile => breakpoint == LayoutBreakpoint.mobile || breakpoint == LayoutBreakpoint.smallMobile;

  /// Returns `true` if screen device size is [LayoutBreakpoint.tablet]
  bool get isTablet => breakpoint == LayoutBreakpoint.tablet;

  /// Returns `true` if screen device size is [LayoutBreakpoint.desktop]
  bool get isDesktop => breakpoint == LayoutBreakpoint.desktop;

  /// Useful for building values based on breakpoints.
  ///
  /// On desktop it will return [onDesktop ?? onTablet ?? onMobile]
  /// On tablet it will return [onTablet ?? onMobile]
  T buildResponsiveValue<T>(T onMobile, {T? onTablet, T? onDesktop}) {
    if (isDesktop) return onDesktop ?? onTablet ?? onMobile;
    if (isTablet) return onTablet ?? onMobile;
    return onMobile;
  }

  /// Returns a ValueNotifier that fires everytime
  /// the **max** keyboard height changes.
  ValueNotifier<double> get maxKeyboardHeight => KeyboardHeightProvider.of(this).maxKeyboardHeight;

  /// Returns a ValueNotifier that fires everytime the keyboard height changes.
  ValueNotifier<double> get keyboardHeight => KeyboardHeightProvider.of(this).keyboardHeight;

  /// Returns the closest [KeyboardHeightProvider] to the tree if any,
  KeyboardHeightProviderState? get maybeKeyboardHeightProvider => KeyboardHeightProvider.maybeOf(this);

  // * Managers
  /// Returns the [LoaderManager] closest to the widget tree.
  LoaderManagerState get loaderManager => LoaderManager.of(this);

  /// Adds an overlay while this task is being executed.
  void showLoading({required String tag, String? message}) => LoaderManager.of(this).showLoading(tag: tag, message: message);

  /// Removes the tasks, and subsequently the loading overlay.
  void hideLoading({required String tag}) => LoaderManager.of(this).hideLoading(tag: tag);

  /// Returns the [AlertManager] closest to the widget tree.
  AlertManagerState get alertManager => AlertManager.of(this);

  /// Adds a new alert.
  void alert({
    required String msg,
    AlertType? type,
    String? id,
    Duration? duration,
  }) =>
      AlertManager.of(this).alert(msg: msg, type: type, id: id, duration: duration);

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

  /// Same as [bottomsheet] but with a widget builder.
  Future<T?> bottomsheetBuilder<T>(
    WidgetBuilder builder, {
    Color? barrierColor,
  }) {
    return showCupertinoModalBottomSheet<T?>(
      context: this,
      builder: builder,
      useRootNavigator: true,
      clipBehavior: Clip.none,
      barrierColor: barrierColor,
      backgroundColor: Colors.transparent,
    );
  }

  /// Shows a BottomSheet with [child] as a child.
  Future<T?> bottomsheet<T>(Widget child, {Color? barrierColor}) {
    return showCupertinoModalBottomSheet<T?>(
      context: this,
      builder: (context) => Padding(
        padding: const EdgeInsets.only(top: 20),
        child: child,
      ),
      useRootNavigator: true,
      elevation: 0,
      shadow: BoxShadow(color: Colors.white.withOpacity(0)),
      clipBehavior: Clip.none,
      barrierColor: barrierColor ?? Colors.black38,
      backgroundColor: Colors.white.withOpacity(0),
    );
  }
}
