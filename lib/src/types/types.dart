import 'package:flutter/widgets.dart';

export 'dialog.dart';

/// Map of keys and values of type String
typedef StringMap = Map<String, String>;

/// Map of String keys and dynamic values.
typedef JSON = Map<String, dynamic>;

/// [VoidCallback] that returns a [Future]
typedef FutureVoidCallback = Future<void> Function();

/// Callback that accepts an [int] through parameters
typedef IntCallback = void Function(int);

/// Callback that accepts an [String] through parameters
typedef StringCallback = void Function(String value);

/// Callback that accepts an [BuildContext] through parameters
typedef VoidContextCallback = void Function(BuildContext context);

/// Callback for bottomsheet builders
typedef BottomSheetBuilder = Future<T?> Function<T>(Widget child);
