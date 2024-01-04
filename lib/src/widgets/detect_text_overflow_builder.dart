import 'package:flutter/material.dart';

/// DetectTextOverflowBuilder
///
/// A widget that determines whether the provided text will overflow
/// given the constraints of its parent widget and the specified maximum
/// number of lines.
///
/// This widget uses a [LayoutBuilder] and a [TextPainter] to measure
/// the size of the given [text] and decides if the text would overflow
/// if constrained to the given number of lines. This is useful for dynamically
/// adjusting the UI based on the content size.
///
/// Parameters:
///   - `textWidget`: The [Text] widget whose content needs to be checked for
/// overflow.
///   - `builder`: A function that takes in a [BuildContext] and a boolean
///                indicating if the text overflows. It returns a widget
///                that can be rendered based on the overflow condition.
///   - `maxLines`: The maximum number of lines allowed for the text. If
///                the text exceeds this number of lines, it is considered as
///                overflowed. Defaults to 1.
///
/// Example Usage:
/// ```dart
/// DetectTextOverflowBuilder(
///   textWidget: Text('Your long text goes here'),
///   maxLines: 2,
///   builder: (context, isOverflowing) {
///     return isOverflowing ? Expanded(child: Text('Text is overflowing'))
///                          : Text('Text fits within limits');
///   },
/// )
/// ```
///
/// Note: This widget does not automatically handle the rendering of
///  overflowed text.
///       It only provides a boolean flag indicating the overflow, which can be
///       used to make rendering decisions.
///
/// Note 2: This method may not be highly efficient, especially for dynamic
/// content or within lists, as it involves layout calculation.
class DetectTextOverflowBuilder extends StatelessWidget {
  /// Creates an instance of DetectTextOverflowBuilder.
  ///
  /// The [text] and [builder] parameters must not be null.
  /// The [maxLines] parameter defaults to 1 if not provided.
  const DetectTextOverflowBuilder({
    required this.text,
    required this.builder,
    super.key,
    this.maxLines,
  });

  /// The text widget to be measured for overflow.
  final Text text;

  /// Function that builds the UI based on the overflow condition.
  // ignore: avoid_positional_boolean_parameters
  final Widget Function(BuildContext ctx, bool hasOverflowed) builder;

  /// Maximum number of lines that the text is allowed
  /// before considering it as overflowed.
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = DefaultTextStyle.of(context).style;

    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(
          text: text.data,
          style: text.style ?? defaultTextStyle,
        );

        // Use a textpainter to determine if it will exceed max lines
        final tp = TextPainter(
          maxLines: maxLines ?? text.maxLines,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          text: span,
        )..layout(maxWidth: constraints.maxWidth);

        // whether the text overflowed or not
        final exceeded = tp.didExceedMaxLines;

        return builder(context, exceeded);
      },
    );
  }
}
