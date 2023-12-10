import 'package:flutter/widgets.dart';

/// When added to the widget tree, keeps track of the keyboard height
/// and provides these values through the context
/// via `context.maxKeyboardHeight` or `context.keyboardHeight`
class KeyboardHeightProvider extends StatefulWidget {
  /// When added to the widget tree, keeps track of the keyboard height
  /// and provides these values through the context
  /// via `context.maxKeyboardHeight` or `context.keyboardHeight`
  const KeyboardHeightProvider({required this.child, super.key});

  /// Widget [child].
  final Widget child;

  /// Returns the closest [KeyboardHeightProviderState] upper in
  /// the widget tree.
  static KeyboardHeightProviderState of(BuildContext context) =>
      context.findAncestorStateOfType<KeyboardHeightProviderState>()!;

  /// Returns the closest [KeyboardHeightProviderState] upper in
  /// the widget tree, if any.
  static KeyboardHeightProviderState? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<KeyboardHeightProviderState>();

  @override
  State<KeyboardHeightProvider> createState() => KeyboardHeightProviderState();
}

/// [KeyboardHeightProvider] state
class KeyboardHeightProviderState extends State<KeyboardHeightProvider>
    with WidgetsBindingObserver {
  /// Keeps track of the current keyboard height
  final ValueNotifier<double> keyboardHeight = ValueNotifier(0);

  /// Keeps track of the max keyboard height while
  /// this widget has been added to the widget tree
  final ValueNotifier<double> maxKeyboardHeight = ValueNotifier(0);

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
  void didChangeMetrics() {
    _onMetricsChanged();
    super.didChangeMetrics();
  }

  void _onMetricsChanged() {
    final current = MediaQuery.viewInsetsOf(context).bottom;
    if (current != keyboardHeight.value) {
      keyboardHeight.value = current;
    }
    if (current > maxKeyboardHeight.value) {
      maxKeyboardHeight.value = current;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
