### 1. Create a RouteObserver<ModalRoute<void>>

```dart
void main() {
  final routeObserver = RouteObserver<ModalRoute<void>>();
  runApp(
    App(routeObserver:routeObserver),
  );
}
```

### 2. Wrap MaterialApp with a RepositoryProvider with the instance created before.

```dart
Widget build(BuildContext context) {
  return  MultiRepositoryProvider(
      providers: [
        // 1. Wrap MaterialApp with RouteObserverProvider.
        RepositoryProvider.value(routeObserver),
      ],
      child: const MaterialApp(...),
    );
}
```

### 3. Pass instance created before to navigatorObservers.

```dart
MaterialApp(
      navigatorObservers: [routeObserver],
      home: const APage(),
)
```

### 4. Add `with RouteAware, RouteObserverMixin` to a StatefulWidget and override RouteAware methods.

```dart
class APage extends StatefulWidget {
  const APage({Key key}) : super(key: key);

  @override
  _APageState createState() => _APageState();
}

// 3. Add `with RouteAware, RouteObserverMixin` to State and override RouteAware methods.
class _APageState extends State<APage> with RouteAware, RouteObserverMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('A Page'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.of(context).push<void>(
              MaterialPageRoute(
                builder: (context) => const BPage(),
              ),
            );
          },
          child: const Text('B Page'),
        ),
      ),
    );
  }

  /// Called when the top route has been popped off, and the current route
  /// shows up.
  @override
  void didPopNext() { }

  /// Called when the current route has been pushed.
  @override
  void didPush() { }

  /// Called when the current route has been popped off.
  @override
  void didPop() { }

  /// Called when a new route has been pushed, and the current route is no
  /// longer visible.
  @override
  void didPushNext() { }
}
```
