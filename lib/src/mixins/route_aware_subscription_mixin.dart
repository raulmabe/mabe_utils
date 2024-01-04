import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// Subscribes and unsusbcribes automatically on the
/// lifetime of the widget adjacent to.
mixin RouteAwareSubscriptionMixin<T extends StatefulWidget>
    on State<T>, RouteAware {
  RouteObserver<ModalRoute<void>>? _routeObserver;

  /// Unsubscribes this widget from the [RouteObserver].
  /// After this is called, [RouteAware] methods won't be called no more.
  void subscribeRouteAware() {
    _routeObserver = context.read<RouteObserver<ModalRoute<void>>>();

    final modalRoute = ModalRoute.of(context);
    if (modalRoute != null) {
      _routeObserver?.subscribe(this, modalRoute);
    }
  }

  /// Unsubscribes this widget from the [RouteObserver].
  /// After this is called, [RouteAware] methods won't be called no more.
  void unsubscribeRouteAware() {
    _routeObserver?.unsubscribe(this);
  }

  @override
  void activate() {
    subscribeRouteAware();
    super.activate();
  }

  @override
  void didChangeDependencies() {
    unsubscribeRouteAware();
    subscribeRouteAware();
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    unsubscribeRouteAware();
    super.deactivate();
  }
}
