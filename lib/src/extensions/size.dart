import 'package:flutter/widgets.dart';

/// Adds extension utility methods to the Size class.
extension SizeExt on Size {
  /// Returns the aspect ratio from this size.
  double get aspectRatio => width / height;
}
