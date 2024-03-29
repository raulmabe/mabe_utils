extension NumExt on num {
  LayoutBreakpoint get toLayout {
    final width = toInt();
    if (width < LayoutBreakpoint.smallMobile.value) return LayoutBreakpoint.smallMobile;
    if (width < LayoutBreakpoint.mobile.value) return LayoutBreakpoint.mobile;
    if (width < LayoutBreakpoint.tablet.value) return LayoutBreakpoint.tablet;
    return LayoutBreakpoint.desktop;
  }

  bool get isSmallMobile => toLayout == LayoutBreakpoint.smallMobile;
  bool get isBigMobile => toLayout == LayoutBreakpoint.mobile;
  bool get isMobile => toLayout == LayoutBreakpoint.mobile || toLayout == LayoutBreakpoint.smallMobile;
  bool get isTablet => toLayout == LayoutBreakpoint.tablet;
  bool get isDesktop => toLayout == LayoutBreakpoint.desktop;
}

extension LayoutBreakpointComparisonOperators on LayoutBreakpoint {
  bool operator <(num other) {
    return value < other;
  }

  bool operator <=(num other) {
    return value <= other;
  }

  bool operator >(num other) {
    return value > other;
  }

  bool operator >=(num other) {
    return value >= other;
  }
}

enum LayoutBreakpoint {
  smallMobile(376),
  mobile(576),
  tablet(1280),
  desktop(1920);

  const LayoutBreakpoint(this.value);
  final int value;
}
