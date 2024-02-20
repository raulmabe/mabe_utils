import 'dart:math';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Common Operations for Iterables with nullable items.
extension IterableOptionalExt<T> on Iterable<T?> {
  /// Returns a new list the the non-null items.
  ///
  /// Same as `where((el) => el != null)`
  List<T> removeNull() {
    final list = <T>[];
    for (final element in this) {
      if (element != null) list.add(element);
    }
    return list;
  }
}

/// Common Operations for Iterables with items.
extension IterableExt<T> on Iterable<T> {
  /// Returns a new list. If `b == true` it will be reversed.
  List<T> reverseIf(bool b) => b ? toList().reversed.toList() : toList();

  /// Returns the item after [value]. If [value] is the last one, it
  /// will return the first one.
  T after(T value) => loop(toList().indexOf(value) + 1);

  /// Returns a new list with [separator] between each element.
  /// If [wrap] is true, it will add a [separator] at the beginning and
  /// at the end.
  List<T> separateBy(T separator, {bool wrap = false}) {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return [];

    final l = [iterator.current];
    while (iterator.moveNext()) {
      l
        ..add(separator)
        ..add(iterator.current);
    }
    return (wrap ? l.hugBy(separator) : l).toList();
  }

  /// Returns a new list with [hugger] at the beginning and at the end.
  Iterable<T> hugBy(T hugger) {
    return [
      hugger,
      ...this,
      hugger,
    ];
  }

  /// Same as [map] but providing the index too.
  Iterable<S> indexedMap<S>(S Function(T item, int index) map) {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return [];

    var index = 0;
    final l = [map(iterator.current, index)];
    while (iterator.moveNext()) {
      ++index;
      l.add(map(iterator.current, index));
    }
    return l;
  }

  /// Adds the [value] to the list if not in the iterable already.
  Iterable<T> putIfAbsent(
    T value, {
    EqualityBuilder<T>? equalityBuilder,
  }) {
    final containsValue = equalityBuilder != null ? any(equalityBuilder) : contains(value);
    if (containsValue) {
      return this;
    } else {
      return [...this, value];
    }
  }

  /// Adds or removes the [value] based on if the value was already
  /// in.
  List<T> toggle(T value) {
    if (contains(value)) {
      final result = toList()..remove(value);
      return result;
    } else {
      final result = toList()..add(value);
      return result;
    }
  }

  /// Returns `true` if the iterable is has an element of type [S].
  bool anyType<S extends T>() {
    return whereType<S>().isNotEmpty;
  }

  /// Extract one random item from the list
  T random() => toList()[Random().nextInt(length)];

  /// Extract random items from the list
  List<T> randomSublist(int count) {
    final list = [...this]..shuffle();
    return list.take(count).toList();
  }

  /// The contrary version of [whereType]. Returns a new
  /// list composed of only the elements that are **NOT** of type [S].
  List<T> whereTypeNot<S extends T>() {
    final extracted = whereType<S>();
    return [
      for (final element in this) extracted.cast<T>().contains(element) ? null : element,
    ].removeNull().cast<T>();
  }

  /// Same as [whereType] but with a pair of types.
  List<T> whereTypes<S extends T, R extends T>() {
    final uniqueValues = {...whereType<S>(), ...whereType<R>()};
    final l = <T>[];
    for (final item in this) {
      if (uniqueValues.contains(item)) l.add(item);
    }
    return l;
  }

  /// The first element satisfying [test], or `null` if there are none.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  /// Returns the last element, and returns null on empty.
  T? get lastOrNull => isEmpty ? null : last;

  /// Returns the first element, and returns null on empty.
  T? get firstOrNull => isEmpty ? null : first;

  /// Returns a map groupped by the [keyFunction].
  Map<K, List<T>> groupBy<K>(K Function(T) keyFunction) => fold(
        <K, List<T>>{},
        (Map<K, List<T>> map, T element) => map..putIfAbsent(keyFunction(element), () => <T>[]).add(element),
      );

  /// Returns the element at position [index] % [length].
  T loop(int index) => toList()[index % length];

  /// Returns the element at index [i] if present. Returns null otherwise
  T? elementAtOrNull(int i) => i >= length ? null : elementAt(i);

  /// Contiguous slices of `this` with the given [length].
  ///
  /// Each slice is [length] elements long, except for the last one which may be
  /// shorter if `this` contains too few elements. Each slice begins after the
  /// last one ends. The [length] must be greater than zero.
  ///
  /// For example, `{1, 2, 3, 4, 5}.slices(2)` returns `([1, 2], [3, 4], [5])`.
  Iterable<List<T>> slices(int length) sync* {
    if (length < 1) throw RangeError.range(length, 1, null, 'length');

    final iterator = this.iterator;
    while (iterator.moveNext()) {
      final slice = [iterator.current];
      for (var i = 1; i < length && iterator.moveNext(); i++) {
        slice.add(iterator.current);
      }
      yield slice;
    }
  }

  /// Transforms an iterable like:
  /// duplicate(3): [a,b] => [a,b,a,b,a,b]
  /// duplicate(2): [a,b] => [a,b,a,b]
  /// duplicate(1): [a,b] => [a,b]
  /// duplicate(0): [a,b] => []
  List<T> duplicate(int x) {
    var l = <T>[];
    for (var i = 0; i < x; ++i) {
      l = [...l, ...this];
    }
    return l;
  }
}

typedef EqualityBuilder<T> = bool Function(T element);

/// Common extensions for Iterables composed of Widgets
extension IterableWidgetExt on Iterable<Widget> {
  /// Adds a [Gap] widget between each element of the list.
  List<Widget> gap(double x, {bool wrap = false}) {
    return separateBy(Gap(x), wrap: wrap).toList();
  }

  /// Adds a borderRadius as it would be added if
  /// the whole list is a full Widget.
  List<Widget> borderRadius(double radius) {
    final list = toList();
    switch (length) {
      case 0:
        return list;
      case 1:
        return [
          ClipRRect(
            borderRadius: SmoothBorderRadius(cornerRadius: radius),
            child: Material(
              type: MaterialType.transparency,
              child: first,
            ),
          ),
        ];
      case _:
        final elementsBetween = <Widget>[];
        for (var i = 1; i < length - 1; ++i) {
          elementsBetween.add(list[i]);
        }
        return [
          ClipRRect(
            borderRadius: SmoothBorderRadius.vertical(
              top: SmoothRadius(cornerRadius: radius, cornerSmoothing: 1),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: first,
            ),
          ),
          ...elementsBetween,
          ClipRRect(
            borderRadius: SmoothBorderRadius.vertical(
              bottom: SmoothRadius(cornerRadius: radius, cornerSmoothing: 1),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: last,
            ),
          ),
        ];
    }
  }
}

/// Common extensions for iterables composed of numbers
extension IterableNumExt on Iterable<num> {
  /// Returns the max number of this list.
  num get max {
    num? x;
    for (final item in this) {
      if (x == null) {
        x = item;
        continue;
      }
      if (item > x) x = item;
    }
    return x ?? 0;
  }

  /// Returns the min number of this list.
  num get min {
    num? x;
    for (final item in this) {
      if (x == null) {
        x = item;
        continue;
      }
      if (item < x) x = item;
    }
    return x ?? 0;
  }

  /// Returns the index where the max number of this list is.
  int get minIndex => toList().indexOf(min);

  /// Returns the index where the min number of this list is.
  int get maxIndex => toList().indexOf(max);
}

/// Common extensions for iterables composed of more lists
extension IterableListExt<T> on Iterable<List<T>> {
  /// Returns a single list composed of each element of the lists inside.
  List<T> get flat {
    final l = <T>[];
    for (final item in this) {
      l.addAll(item);
    }
    return l;
  }
}

/// Common extensions for iterables composed of enums
extension EnumByName<T extends Enum> on Iterable<T> {
  /// Returns the enum with name same as [name].
  /// Null otherwise
  T? byNameOrNull(String name) {
    for (final value in this) {
      if (value.name == name) return value;
    }
    return null;
  }
}
