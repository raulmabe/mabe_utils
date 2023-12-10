import 'package:flutter/material.dart';

/// Common extensions for [GlobalKey]s
extension GlobalKeyExt on GlobalKey<State<StatefulWidget>> {
  /// Returns the global offset of the widget attached to this key.
  Offset? get offset {
    try {
      if (currentState?.mounted == false) return null;
      final renderBox = currentContext?.findRenderObject() as RenderBox?;
      final translation = renderBox?.getTransformTo(null).getTranslation();
      if (translation == null) return null;
      return Offset(translation.x, translation.y);
    } catch (er) {
      return null;
    }
  }

  /// Returns the size of the widget attached to this key.
  Size? get size {
    try {
      if (currentState?.mounted == false) return null;
      final renderBox = currentContext?.findRenderObject() as RenderBox?;
      return renderBox?.size;
    } catch (er) {
      return null;
    }
  }

  /// Returns a Rect of this widget based on the global offset and its size.
  Rect? get rect {
    final _offset = offset;
    if (_offset == null) return null;
    final _size = size;
    if (_size == null) return null;
    return _offset & _size;
  }
}
