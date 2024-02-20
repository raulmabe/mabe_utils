import 'package:flutter/material.dart';
import 'package:mabe_utils/mabe_utils.dart';
import 'package:sprung/sprung.dart';

/// Typedef for the overlay widget builder
typedef OverlayBuilder = Widget Function(
  BuildContext context,
  void Function([OverlayAlignment? alignment]) show,
  FutureVoidCallback remove,
  bool isOpen,
);

/// Typedef for the overlay alignment
typedef OverlayAlignment = ({Alignment targetAnchor, Alignment followerAnchor, Offset? offset});

/// `MabeOverlay` is a StatefulWidget that creates a custom overlay widget.
/// It allows for the display of an overlay widget above other widgets,
/// with customizable positioning and behavior.
class MabeOverlay extends StatefulWidget {
  /// Creates a [MabeOverlay].
  ///
  /// The [overlayBuilder] and [child] parameters are required and
  /// must not be null.
  /// [overlayBuilder] defines the widget to be shown as the overlay.
  /// [child] is the underlying widget over which the overlay is shown.
  ///
  /// Optional parameters include [overlayDecoration], [barrierColor],
  /// [onDismissed], and [alignment]
  /// for further customization of the overlay's appearance and behavior.
  const MabeOverlay({
    required this.overlayBuilder,
    required this.child,
    super.key,
    this.overlayDecoration,
    this.barrierColor,
    this.overlayPadding,
    this.onDismissed,
    this.alignment = (followerAnchor: Alignment.bottomCenter, targetAnchor: Alignment.topCenter, offset: null),
    this.animationDuration = const Duration(milliseconds: 250),
  });

  /// Builder function to create the overlay widget.
  ///
  /// This function is called to construct the overlay widget. It provides
  /// the context, a function to show the overlay, a function to remove the overlay,
  /// and a boolean indicating if the overlay is open.
  final OverlayBuilder overlayBuilder;

  /// The underlying child widget over which the overlay is shown.
  final OverlayBuilder child;

  /// The background decoration for the overlay.
  ///
  /// If null, the overlay will not have any background.
  final BoxDecoration? overlayDecoration;

  /// The padding for the overlay content.
  final EdgeInsets? overlayPadding;

  /// Callback function that is called when the overlay is dismissed.
  final VoidCallback? onDismissed;

  /// Defines the alignment of the overlay relative to the [child].
  ///
  /// This alignment is used to position the overlay widget in relation to
  /// the child widget. It consists of target and follower anchor points
  /// and an optional offset.
  final OverlayAlignment alignment;

  /// The color of the barrier behind the overlay.
  ///
  /// If null, the barrier will be transparent.
  final Color? barrierColor;

  /// The duration of the show/hide animation.
  final Duration animationDuration;

  @override
  State<MabeOverlay> createState() => _AwesomeOverlayState();
}

class _AwesomeOverlayState extends State<MabeOverlay> {
  OverlayEntry? entry;
  late LayerLink _layerLink;

  bool toBeRemoved = false;

  late ValueNotifier<bool> _isOpen;

  @override
  void initState() {
    super.initState();
    _isOpen = ValueNotifier(false);
    _layerLink = LayerLink();
  }

  void showOverlay([OverlayAlignment? alignment]) {
    _isOpen.value = true;

    final overlayState = Overlay.of(context);
    if (entry != null) {
      if (entry!.mounted) entry!.remove();
      entry!.dispose();
    }
    entry = OverlayEntry(
      builder: (ctx) => Container(
        color: widget.barrierColor,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: removeOverlay,
          child: Stack(
            children: [
              CompositedTransformFollower(
                link: _layerLink,
                offset: alignment?.offset ?? widget.alignment.offset ?? const Offset(0, -20),
                targetAnchor: alignment?.targetAnchor ?? widget.alignment.targetAnchor,
                followerAnchor: alignment?.followerAnchor ?? widget.alignment.followerAnchor,
                child: buildOverlay(ctx, alignment),
              ),
            ],
          ),
        ),
      ),
    );

    overlayState.insert(entry!);
  }

  Future<void> removeOverlay() async {
    _isOpen.value = false;
    toBeRemoved = true;
    entry?.markNeedsBuild();

    return Future.delayed(widget.animationDuration, () {
      if (toBeRemoved) {
        if (entry != null && entry!.mounted) {
          entry?.remove();
        }
        toBeRemoved = false;
      }

      widget.onDismissed?.call();
    });
  }

  @override
  void dispose() {
    if (entry?.mounted ?? false) {
      entry?.remove();
    }
    entry?.dispose();
    _isOpen.dispose();
    super.dispose();
  }

  Widget buildOverlay(BuildContext context, OverlayAlignment? alignment) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: toBeRemoved ? 0 : 1),
      duration: widget.animationDuration,
      curve: Sprung.criticallyDamped,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          alignment: alignment?.followerAnchor ?? widget.alignment.followerAnchor,
          child: child,
        );
      },
      child: DecoratedBox(
        decoration: widget.overlayDecoration ?? const BoxDecoration(),
        child: Material(
          borderRadius: widget.overlayDecoration?.borderRadius,
          type: MaterialType.transparency,
          child: ClipRRect(
            borderRadius: widget.overlayDecoration?.borderRadius ?? BorderRadius.zero,
            child: Padding(
              padding: widget.overlayPadding ?? const EdgeInsets.all(8),
              child: ListenableBuilder(
                listenable: _isOpen,
                builder: (context, _) => widget.overlayBuilder(
                  context,
                  showOverlay,
                  removeOverlay,
                  _isOpen.value,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: ListenableBuilder(
        listenable: _isOpen,
        builder: (context, _) => widget.child(context, showOverlay, removeOverlay, _isOpen.value),
      ),
    );
  }
}
