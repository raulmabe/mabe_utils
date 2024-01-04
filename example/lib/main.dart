import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mabe_utils/mabe_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    );
    return MaterialApp(
      title: 'Mabe Utils Demo',
      theme: theme,
      builder: (context, child) => DefaultTextStyle(
        style: theme.textTheme.bodyMedium!,
        child: KeyboardHeightProvider(
          child: LoaderManager(
            loadingOverlay: (context) => const LoadingOverlay(),
            child: AlertManager(
              child: child!,
              alertBuilder: (alert) => Alert(data: alert),
            ),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mabe Utils Example'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: Colors.blueGrey.shade50,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            /// * Access to keyboard height
            ValueListenableBuilder(
              valueListenable: context.keyboardHeight,
              builder: (context, height, _) => Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                color: Colors.green.shade50,
                alignment: Alignment.center,
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: 'Current Keyboard Height: '),
                      TextSpan(
                        text: height.toString(),
                        style: context.theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.green.shade700,
                  ),
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: context.maxKeyboardHeight,
              builder: (context, height, _) => Container(
                color: Colors.orange.shade50,
                padding: const EdgeInsets.symmetric(vertical: 16),
                alignment: Alignment.center,
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: 'Max Keyboard Height: '),
                      TextSpan(
                        text: height.toString(),
                        style: context.theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.orange.shade700,
                  ),
                ),
              ),
            ),
            const TextField(),

            /// * Disabled Widget
            Disabled(
              reason: 'Service is not available',
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Disabled Button'),
              ),
            ),

            /// * Loading Widget
            ElevatedButton(
              onPressed: () async {
                final hideLoading = context.hideLoading;

                context.showLoading(tag: kLoadingTask);
                await Future.delayed(const Duration(seconds: 3));
                hideLoading(tag: kLoadingTask);
              },
              child: const Text('Show Loading'),
            ),
            MabeOverlay(
              overlayDecoration: const BoxDecoration(
                color: Colors.indigo,
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo,
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                ],
              ),
              overlayBuilder: (context, show, remove, isOpen) => SizedBox(
                width: context.screen.width * .5,
                child: const Text(
                  'This is an overlay. Automatically dismisses when tapping outside',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              child: (context, show, remove, isOpen) => ElevatedButton(
                onPressed: !isOpen ? show : null,
                child: const Text('Show Loading'),
              ),
            ),
            DetectTextOverflowBuilder(
              text: const Text(
                'This is a long text that does overflow, so it does not show the whole content',
                maxLines: 1,
              ),
              builder: (ctx, hasOverflowed) =>
                  Text('The text I introduced has overflowed? $hasOverflowed'),
            ),
            ReactOnTap(
              onTap: () {
                log('Reacting on Tap');
              },
              child: Container(
                height: 100,
                decoration: const BoxDecoration(color: Colors.pink),
              ),
            ),
          ].gap(20),
        ),
      ),
    );
  }
}

class Alert extends StatelessWidget {
  const Alert({
    super.key,
    required this.data,
    this.backgroundColor,
    this.style,
  });

  final Color? backgroundColor;
  final TextStyle? style;
  final AlertData data;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(data.id),
      direction: DismissDirection.up,
      onDismissed: (_) => AlertManager.of(context).dismiss(),
      child: ReactOnTap(
        onTap: () {
          AlertManager.of(context).dismiss();
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          decoration: BoxDecoration(
              color: backgroundColor ??
                  switch (data.type) {
                    AlertType.error => Colors.red.shade100,
                    AlertType.success => Colors.green.shade100,
                    _ => Colors.blue.shade100,
                  },
              borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(switch (data.type) {
                AlertType.success => Icons.check_circle_rounded,
                _ => Icons.info,
              }),
              Expanded(
                  child: Text(
                data.message,
                style: style,
              ))
            ].gap(16),
          ),
        ),
      ),
    );
  }
}

const kLoadingTask = 'image-downloading';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.withOpacity(.5),
      alignment: Alignment.center,
      child: const Text('Loading for 3 seconds... '),
    );
  }
}
