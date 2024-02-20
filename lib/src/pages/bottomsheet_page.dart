import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

/// `BottomSheetPage` is a custom page class that integrates with
/// the Flutter navigation system, specifically designed to present a
/// bottom sheet using `CupertinoModalBottomSheetRoute`.
/// It is compatible with `go_router` and other routing packages.
class BottomSheetPage<T> extends Page<T> {
  /// Creates a [BottomSheetPage].
  ///
  /// The [child] argument must not be null and is
  /// the content displayed in the bottom sheet.
  const BottomSheetPage({
    required this.child,
    this.isDismissible = true,
    this.isExpanded = true,
    this.modalBarrierColor,
    this.duration,
    this.overlayStyle,
  });

  /// The widget to display inside the bottom sheet.
  ///
  /// This is typically a layout widget containing
  /// the content for the bottom sheet.
  final Widget child;

  /// Determines whether the bottom sheet can be dismissed.
  ///
  /// If true, the bottom sheet can be dismissed by
  /// tapping outside its bounds or by swiping down.
  /// Defaults to true.
  final bool isDismissible;

  /// The duration of the bottom sheet's animation.
  ///
  /// If null, the bottom sheet uses the default duration for bottom sheet
  /// animations. Otherwise, this duration is used when opening
  /// and closing the bottom sheet.
  final Duration? duration;

  /// Color for the barrier. Defaults to Color.black12
  final Color? modalBarrierColor;

  /// Overlay Style
  final SystemUiOverlayStyle? overlayStyle;

  /// Forces the widget to be expanded when true.
  final bool isExpanded;

  @override
  Route<T> createRoute(BuildContext context) => CupertinoModalBottomSheetRoute<T>(
        builder: (context) => child,
        expanded: isExpanded,
        isDismissible: isDismissible,
        enableDrag: isDismissible,
        modalBarrierColor: modalBarrierColor,
        settings: this,
        duration: duration,
        overlayStyle: overlayStyle,
      );
}
