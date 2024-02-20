import 'package:mabe_utils/mabe_utils.dart';

/// Extension methods for JSONs
extension JsonExt on JSON {
  /// Returns the a new JSON with only the keys specified.
  JSON filter(List<String> keys) {
    final map = <String, dynamic>{};
    for (final MapEntry(:key, :value) in entries) {
      if (keys.contains(key)) {
        map[key] = value;
      }
    }
    return map;
  }
}
