[<img src="https://raulmabe.dev/favicon_io/favicon.ico" align="left" />](https://cli.vgv.dev/)

### Mabe Utils

<br clear="left"/>

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

Utils Code by MABE

## Installation 💻

**❗ In order to start using Mabe Utils you must have the [Flutter SDK][flutter_install_link] installed on your machine.**

Install via `flutter pub add`:

```sh
dart pub add mabe_utils
```

---

## Widgets

Look at the `example` folder to check how to work with these widgets.

- ReactOnTap
  - Scale
  - Opacity [Pending]
- Disabled
  - Marks `child` as disabled by reducing its opacity to half and ignoring pointers.
- KeyboardHeightProvider
  - When added to the widget tree, keeps track of the keyboard height and provides these values through the context via `context.maxKeyboardHeight` or `context.keyboardHeight`
- LoadingManager
  - Adds an overlay on top of all the sub-widget tree when loading. Allows to add loading tasks
- AlertManager
  - `AlertManager` which provides functionality to add or remove alerts above the sub-widget tree. Use it like `context.alert(msg: msg)`

## Types

```jsx
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
```

## Extensions

**Iterables & Lists**

```dart
List<T> removeNull()

List<T> reverseIf(bool b);

T after(T value);

List<T> separateBy(T separator, {bool wrap = false});

Iterable<T> hugBy(T hugger);

Iterable<S> indexedMap<S>(S Function(T item, int index) map);

Iterable<T> putIfAbsent(T value, {EqualityBuilder<T>? equalityBuilder});

/// Adds or removes the [value] based on if the value was already in.
List<T> toggle(T value);

/// Returns `true` if the iterable is has an element of type [S].
bool anyType<S extends T>();

/// Extract one random item from the list
T random();

/// Extract random items from the list
List<T> randomSublist(int count);

/// The contrary version of [whereType]. Returns a new
/// list composed of only the elements that are **NOT** of type [S].
List<T> whereTypeNot<S extends T>();

/// Same as [whereType] but with a pair of types.
List<T> whereTypes<S extends T, R extends T>();

/// The first element satisfying [test], or `null` if there are none.
T? firstWhereOrNull(bool Function(T element) test);

/// Returns the last element, and returns null on empty.
T? get lastOrNull;

/// Returns the first element, and returns null on empty.
T? get firstOrNull;

/// Returns a map groupped by the [keyFunction].
Map<K, List<T>> groupBy<K>(K Function(T) keyFunction);

/// Returns the element at position [index] % [length].
T loop(int index);

/// Returns the element at index [i] if present. Returns null otherwise
T? elementAtOrNull(int i);

/// Contiguous slices of `this` with the given [length].
///
/// Each slice is [length] elements long, except for the last one which may be
/// shorter if `this` contains too few elements. Each slice begins after the
/// last one ends. The [length] must be greater than zero.
///
/// For example, `{1, 2, 3, 4, 5}.slices(2)` returns `([1, 2], [3, 4], [5])`.
Iterable<List<T>> slices(int length);

```

**Context**

```dart
  /// Equivalent as `Navigator.of(context)`
  NavigatorState get navigator => Navigator.of(this);

  /// Equivalent as `MediaQuery.sizeOf(context)`
  Size get screen => MediaQuery.sizeOf(this);

  /// Equivalent as `MediaQuery.of(context)`
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Returns padding for the nearest MediaQuery ancestor or
  /// throws an exception, if no such ancestor exists.
  EdgeInsets get padding => MediaQuery.paddingOf(this);

  /// Equivalent as `Theme.of(context)`
  ThemeData get theme => Theme.of(this);

  /// Returns the current [LayoutBreakpoint] based on screen device size.
  LayoutBreakpoint get breakpoint;

  /// Returns `true` if screen device size is [LayoutBreakpoint.mobile]
  bool get isMobile;

  /// Returns `true` if screen device size is [LayoutBreakpoint.tablet]
  bool get isTablet;

  /// Returns `true` if screen device size is [LayoutBreakpoint.desktop]
  bool get isDesktop;

  /// Returns a ValueNotifier that fires everytime
  /// the **max** keyboard height changes.
  ValueNotifier<double> get maxKeyboardHeight;

  /// Returns a ValueNotifier that fires everytime the keyboard height changes.
  ValueNotifier<double> get keyboardHeight;

  /// Returns the closest [KeyboardHeightProvider] to the tree if any,
  KeyboardHeightProviderState? get maybeKeyboardHeightProvider;

  // * Managers
  /// Adds an overlay while this task is being executed.
  void showLoading({required String tag, String? message});

  /// Removes the tasks, and subsequently the loading overlay.
  void hideLoading({required String tag});

  /// Adds a new alert.
  void alert({
    required String msg,
    AlertType? type,
    String? id,
    Duration? duration,
  });

  /// It shows a Dialog and will the corresponding [AppDialogAction].
  Future<AppDialogAction> popup(
    Widget dialog, {
    Color? barrierColor,
    bool? isDismissable,
  });

	/// Same as [bottomsheet] but with a widget builder.
  Future<T?> bottomsheetBuilder<T>(WidgetBuilder builder,{Color? barrierColor});

  /// Shows a BottomSheet with [child] as a child.
  Future<T?> bottomsheet<T>(Widget child, {Color? barrierColor});
```

**GlobalKey**

```dart
 	/// Returns the global offset of the widget attached to this key.
  Offset? get offset;

  /// Returns the size of the widget attached to this key.
  Size? get size;

  /// Returns a Rect of this widget based on the global offset and its size.
  Rect? get rect;
```

**String**

```dart
 Color get color;

	/// Returns the initial letter of each word
  String get initials;

  /// Returns the same string but the first letter is uppercase.
  String get capitalized;

  /// Transforms a camel case to a sentence case.
  /// Example: camelToSentence -> Camel To Sentence
  String get camelCaseToSentenceCase;
```

And more ✨

[flutter_install_link]: https://docs.flutter.dev/get-started/install
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logo_black]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_black.png#gh-light-mode-only
[logo_white]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_white.png#gh-dark-mode-only
[mason_link]: https://github.com/felangel/mason
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://pub.dev/packages/very_good_cli
[very_good_coverage_link]: https://github.com/marketplace/actions/very-good-coverage
[very_good_ventures_link]: https://verygood.ventures
[very_good_ventures_link_light]: https://verygood.ventures#gh-light-mode-only
[very_good_ventures_link_dark]: https://verygood.ventures#gh-dark-mode-only
[very_good_workflows_link]: https://github.com/VeryGoodOpenSource/very_good_workflows
