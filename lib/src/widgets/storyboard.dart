import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mabe_utils/mabe_utils.dart';

/// Builder for the stories.
typedef StoryBuilder = Widget Function(
  BuildContext context,
  AnimationController controller,
  double headerHeight,
);

/// A customizable widget for creating Instagram-like storyboards in Flutter.
///
/// The `Storyboard` widget allows for the display of a series of stories,
/// each represented by a custom widget. It provides functionality for
/// auto-play, manual navigation between stories, and displaying
/// an optional header.
class Storyboard extends StatefulWidget {
  /// Default and only constructor
  const Storyboard({
    required this.stories,
    this.storyDuration = const Duration(seconds: 3),
    this.unselectedIndicatorDecoration =
        const BoxDecoration(color: Colors.white24),
    this.selectedIndicatorDecoration = const BoxDecoration(color: Colors.white),
    this.indicatorHeight = 3.0,
    this.indicatorGap = 6.0,
    this.autoPlay = true,
    super.key,
    this.header,
    this.onEnd,
  });

  /// A list of `StoryBuilder` functions that define each story's content.
  final List<StoryBuilder> stories;

  /// The duration each story is displayed during auto-play.
  ///
  /// Defaults to 3 seconds.
  final Duration storyDuration;

  /// The decoration for unselected story indicators.
  ///
  /// Defaults to a white24 color.
  final BoxDecoration unselectedIndicatorDecoration;

  /// The decoration for the currently selected story indicator.
  ///
  /// Defaults to white color.
  final BoxDecoration selectedIndicatorDecoration;

  /// - [indicatorHeight]: The height of the story indicators. Defaults to 3.0.
  final double indicatorHeight;

  /// - [indicatorGap]: The gap between story indicators. Defaults to 6.0.
  final double indicatorGap;

  /// - [autoPlay]: A boolean value that controls if stories should play
  /// automatically.
  ///
  /// Defaults to true.
  final bool autoPlay;

  /// - [header]: An optional `PreferredSize` widget to display above the
  /// stories, such as a custom app bar.
  final PreferredSize? header;

  /// - [onEnd]: An optional callback that is called when the last story ends.
  final VoidCallback? onEnd;

  @override
  State<Storyboard> createState() => _StoryboardState();
}

class _StoryboardState extends State<Storyboard>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  late final ValueNotifier<int> index;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: widget.storyDuration)
          ..addStatusListener(_onControllerStatusChanged);
    index = ValueNotifier(0);

    if (widget.autoPlay) {
      controller.forward();
    }
  }

  void _onControllerStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      nextStory();
    }
  }

  void onEnd() {
    log('END');
    widget.onEnd?.call();
  }

  void nextStory() {
    final nextValue = (index.value + 1).clamp(0, widget.stories.length - 1);
    if (index.value == nextValue) return onEnd();
    index.value = nextValue;
    controller.forward(from: 0);
  }

  void prevStory() {
    final shouldChangeStory = controller.value < .2;
    if (shouldChangeStory) {
      index.value = (index.value - 1).clamp(0, widget.stories.length);
    }
    controller.forward(from: 0);
  }

  void pause() {
    controller.stop();
  }

  void play() {
    controller.forward();
  }

  void restart() => controller.forward(from: 0);

  @override
  void dispose() {
    index.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final headerHeight = (kToolbarHeight / 2) +
        MediaQuery.viewPaddingOf(context).top +
        (widget.header?.preferredSize.height ?? 0);

    return Stack(
      children: [
        Positioned.fill(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ValueListenableBuilder(
                valueListenable: index,
                builder: (context, value, child) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapUp: (details) {
                      final midWidth = constraints.maxWidth * .5;
                      if (details.localPosition.dx > midWidth) {
                        log(' NEXT STORY');
                        nextStory();
                      } else {
                        log(' PREV STORY');
                        prevStory();
                      }
                    },
                    onLongPressDown: (details) {
                      log('PAUSE');
                      pause();
                    },
                    onLongPressUp: () {
                      log('PLAY');
                      play();
                    },
                    child: widget.stories[value](
                      context,
                      controller,
                      headerHeight,
                    ),
                  );
                },
              );
            },
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: headerHeight,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              bottom: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: List.generate(
                      widget.stories.length,
                      (i) => Expanded(
                        child: Container(
                          decoration: widget.unselectedIndicatorDecoration,
                          alignment: Alignment.centerLeft,
                          height: widget.indicatorHeight,
                          child: DecoratedBox(
                            decoration: widget.selectedIndicatorDecoration,
                            child: AnimatedBuilder(
                              animation: controller,
                              builder: (context, child) {
                                final value = switch (index.value) {
                                  _ when i == index.value => controller.value,
                                  _ when i < index.value => 1.0,
                                  _ => 0.0,
                                };
                                return FractionallySizedBox(
                                  widthFactor: value,
                                  heightFactor: 1,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ).gap(widget.indicatorGap, wrap: true),
                  ),
                  if (widget.header != null) widget.header!,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
