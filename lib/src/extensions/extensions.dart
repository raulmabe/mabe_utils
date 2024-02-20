export 'color.dart';
export 'context.dart';
export 'file.dart';
export 'iterable.dart';
export 'json.dart';
export 'keys.dart';
export 'layout_breakpoint.dart';
export 'object.dart';
export 'strings.dart';

/// Allows to use the operator + on null values aswell.
extension OptionalInfixAddition<T extends num> on T? {
  /// Allows to use the operator + on null values aswell.
  T? operator +(T? other) {
    final shadow = this;
    if (shadow == null) return null;
    return shadow + (other ?? 0) as T;
  }
}
