// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:mabe_utils/mabe_utils.dart';

/// [AlertManager] which provides functionalty to add or remove alerts above
/// the subwidget tree.
///
/// Use it like `context.alert(msg: msg)`
class AlertManager extends StatefulWidget {
  /// [AlertManager] which provides functionalty to add or remove alerts above
  /// the subwidget tree.
  ///
  /// Use it like `context.alert(msg: msg)`
  const AlertManager({
    required this.child,
    this.alertBuilder = defaultAlertBuilder,
    this.alignment = Alignment.topCenter,
    this.defaultAlertType = AlertType.info,
    this.defaultDuration = const Duration(seconds: 3),
    super.key,
  });

  /// Returns the [AlertManagerState] object of the nearest ancestor
  ///[StatefulWidget] widget.
  static AlertManagerState of(BuildContext context) => context.findAncestorStateOfType<AlertManagerState>()!;

  /// Returns the [AlertManagerState] object of the nearest ancestor (if any)
  ///[StatefulWidget] widget.
  static AlertManagerState? maybeOf(BuildContext context) => context.findAncestorStateOfType<AlertManagerState>();

  /// Widget [child]
  final Widget child;

  /// Function that builds the Widget associated to the alert.
  final AlertBuilder alertBuilder;

  /// Alignment to position the alert.
  final Alignment alignment;

  /// Overrides the default alert type. This AlertType will be used
  /// when AlertType is not specified.
  final AlertType defaultAlertType;

  /// Overrides the default alert type.
  final Duration defaultDuration;

  @override
  State<AlertManager> createState() => AlertManagerState();
}

/// [AlertManager] state
class AlertManagerState extends State<AlertManager> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<AlertData> _alerts;
  bool _isActive = false;

  @override
  void initState() {
    super.initState();

    _alerts = [];
    _animationController = AnimationController(vsync: this);

    _animationController.addStatusListener(_onTimeExceeded);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: widget.alignment,
      children: [
        widget.child,
        SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              _isActive = !(_alerts.length <= 1 && _animationController.status == AnimationStatus.completed);

              return IgnorePointer(
                ignoring: !_isActive,
                child: AnimatedOpacity(
                  duration: _fadeDuration,
                  opacity: _isActive ? 1 : 0,
                  child: child,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
              ),
              child: _alerts.isEmpty ? const SizedBox() : widget.alertBuilder(_alerts[0]),
            ),
          ),
        ),
      ],
    );
  }

  Duration get _fadeDuration => const Duration(milliseconds: 250);

  void _onTimeExceeded(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _removeFirst();
    }
  }

  /// Dismisses the current alert
  void dismiss() {
    _animationController.animateTo(1, duration: Duration.zero);
  }

  void _removeFirst() {
    Future.delayed(
      _fadeDuration,
      () => setState(() {
        if (_alerts.isNotEmpty) _alerts.removeAt(0);

        if (_alerts.isNotEmpty) {
          final duration = _alerts.isNotEmpty ? _alerts[0].duration : null;
          _animationController
            ..duration = duration ?? widget.defaultDuration
            ..forward(from: 0);
        }
      }),
    );
  }

  /// Adds a new alert.
  void alert({
    required String msg,
    AlertType? type,
    String? id,
    Duration? duration,
  }) {
    setState(() {
      _alerts
        ..removeWhere((element) => element.id == id)
        ..add(
          (
            id: id ?? msg,
            type: type ?? widget.defaultAlertType,
            duration: duration ?? widget.defaultDuration,
            message: msg,
          ),
        );
    });

    _animationController
      ..duration = duration ?? widget.defaultDuration
      ..forward(from: 0);
  }
}

/// AlertType composes of success, info, or error.
enum AlertType {
  /// Task succeded
  success,

  /// Inform the user
  info,

  /// Task did not finish successfully
  error;
}

/// Alert Builder Utility Function
typedef AlertBuilder = Widget Function(AlertData data);

/// The data that an Alert needs.
typedef AlertData = ({String id, AlertType type, String message, Duration duration});

/// Default alert builder to easily set it up
Widget defaultAlertBuilder(AlertData data) => _Alert(data: data);

class _Alert extends StatelessWidget {
  const _Alert({
    required this.data,
    super.key,
    this.backgroundColor,
    this.style,
  });

  final Color? backgroundColor;
  final TextStyle? style;
  final AlertData data;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(data.id),
      direction: DismissDirection.up,
      onDismissed: (_) => AlertManager.of(context).dismiss(),
      child: ReactOnTap(
        onTap: () {
          AlertManager.of(context).dismiss();
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          decoration: BoxDecoration(
            color: backgroundColor ??
                switch (data.type) {
                  AlertType.error => Colors.red.shade100,
                  AlertType.success => Colors.green.shade100,
                  _ => Colors.blue.shade100,
                },
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(
                switch (data.type) {
                  AlertType.success => Icons.check_circle_rounded,
                  _ => Icons.info,
                },
              ),
              Expanded(
                child: Text(
                  data.message,
                  style: style,
                ),
              ),
            ].gap(16),
          ),
        ),
      ),
    );
  }
}
