import 'package:flutter/material.dart';

/// Common extensions for Color
extension ColorExt on Color {
  /// Creates a darker color
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1, 'amount must be between 0 and 1');

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  /// Creates a lighter color
  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1, 'amount must be between 0 and 1');

    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  /// Mixes a color with [another]. [amount] is from 0 to 1.
  Color? mix(Color another, double amount) => Color.lerp(this, another, amount);
}
