import 'package:flutter/material.dart';

/// Common String Extensions
extension StringExt on String {
  /// Returns the initial letter of each word
  String get initials {
    final name = trim();
    if (isEmpty) return '';
    if (name.split(' ').length > 1) {
      return name.split(' ').map((l) => l[0]).take(2).join().toUpperCase();
    }
    if (name.split(' ')[0].length > 1) {
      return name.split(' ')[0][0].toUpperCase() +
          name.split(' ')[0][1].toUpperCase();
    }
    return name.split(' ')[0].toUpperCase();
  }

  /// Returns the same string but the first letter is uppercase.
  String get capitalized {
    if (isEmpty) {
      return this;
    } else {
      return this[0].toUpperCase() + substring(1);
    }
  }

  /// Transforms a camel case to a sentence case.
  /// Example: camelToSentence -> Camel To Sentence
  String get camelCaseToSentenceCase {
    final result = replaceAll(RegExp('(?<!^)(?=[A-Z])'), ' ');
    final finalResult = result[0].toUpperCase() + result.substring(1);
    return finalResult;
  }
}

/// Color related String Extensions
extension StringColor on String {
  /// Returns a Color based on a HEX formatted String
  Color get color {
    var number = 0.0;
    for (var i = 0; i < length; i++) {
      number += codeUnitAt(i);
    }

    number = (number % 240) * 1.5;
    return HSLColor.fromColor(Colors.blue).withHue(number).toColor();
  }
}
