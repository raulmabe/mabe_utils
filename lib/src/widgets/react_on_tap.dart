import 'package:flutter/material.dart';

/// Adds a reaction to the [child] widget when tapped.
class ReactOnTap extends StatefulWidget {
  /// Adds a scale and opacity animation to the [child] widget when tapped.
  const ReactOnTap({
    required this.child,
    super.key,
    this.onTap,
    this.onDoubleTap,
    this.onLongTap,
    this.forceScale = false,
    this.duration = const Duration(milliseconds: 100),
    this.factorScale = .97,
    this.opacity = .5,
    this.alignment = Alignment.center,
    this.behavior = HitTestBehavior.deferToChild,
    this.padding,
  });

  /// Adds a scale animation to the [child] widget when tapped.
  const ReactOnTap.scale({
    required this.child,
    super.key,
    this.onTap,
    this.onDoubleTap,
    this.onLongTap,
    this.forceScale = false,
    this.duration = const Duration(milliseconds: 100),
    this.factorScale = .97,
    this.alignment = Alignment.center,
    this.behavior = HitTestBehavior.deferToChild,
    this.padding,
  }) : opacity = 1;

  /// Adds a opacity animation to the [child] widget when tapped.
  const ReactOnTap.opacity({
    required this.child,
    super.key,
    this.onTap,
    this.onDoubleTap,
    this.onLongTap,
    this.forceScale = false,
    this.duration = const Duration(milliseconds: 100),
    this.opacity = .5,
    this.alignment = Alignment.center,
    this.behavior = HitTestBehavior.deferToChild,
    this.padding,
  }) : factorScale = 1;

  /// Widget [child].
  final Widget child;

  /// Callback fired when tapped.
  final VoidCallback? onTap;

  /// Callback fired when double tapped.
  final VoidCallback? onDoubleTap;

  /// Callback fired when long tapped.
  final VoidCallback? onLongTap;

  /// Customize the [HitTestBehavior].
  final HitTestBehavior behavior;

  /// The alignment for the animation running.
  final Alignment? alignment;

  /// Adds padding between [child] and the hit area.
  final EdgeInsets? padding;

  /// Forces animation even though callbacks like [onTap] are null.
  final bool forceScale;

  /// Allows to customize the amount of scale when animating.
  final double factorScale;

  /// Allows to customize the amount of opacity when animating.
  final double opacity;

  /// Sets the animation duration.
  final Duration duration;

  @override
  _ReactOnTapState createState() => _ReactOnTapState();
}

class _ReactOnTapState extends State<ReactOnTap> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scale;
  late Animation<double> _opacity;
  late final CurvedAnimation _curvedAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: widget.duration);

    _curvedAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

    _opacity = Tween<double>(begin: 1, end: widget.opacity).animate(_animationController);
    _scale = Tween<double>(
      begin: 1,
      end: 1,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _curvedAnimation.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTappable = widget.onDoubleTap != null || widget.onTap != null || widget.onLongTap != null;
    final mustScale = isTappable || widget.forceScale;

    if (!mustScale) return widget.child;

    return Listener(
      onPointerDown: _onTapDown,
      onPointerUp: _onTapUp,
      onPointerCancel: _onTapUp,
      behavior: widget.behavior,
      child: GestureDetector(
        behavior: widget.behavior,
        onTap: widget.onTap,
        onDoubleTap: widget.onDoubleTap,
        onLongPress: widget.onLongTap,
        child: Padding(
          padding: widget.padding ?? EdgeInsets.zero,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scale.value,
                alignment: widget.alignment,
                child: Opacity(
                  opacity: _opacity.value,
                  child: child,
                ),
              );
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }

  void _onTapDown(_) => animate(widget.factorScale, widget.opacity);
  void _onTapUp(_) => animate(1, 1);

  void animate(double scale, double opacity) {
    if (!mounted) return;
    _animationController.stop();

    _scale = Tween<double>(begin: _scale.value, end: scale).animate(
      _curvedAnimation,
    );
    _opacity = Tween<double>(begin: _opacity.value, end: opacity).animate(
      _curvedAnimation,
    );

    _animationController
      ..reset()
      ..forward();
  }
}
