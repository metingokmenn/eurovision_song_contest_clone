import 'package:flutter/material.dart';

class AnimationProvider extends StatefulWidget {
  final Widget child;
  final Function(TickerProvider vsync) onInitialize;

  const AnimationProvider({
    Key? key,
    required this.child,
    required this.onInitialize,
  }) : super(key: key);

  @override
  State<AnimationProvider> createState() => _AnimationProviderState();
}

class _AnimationProviderState extends State<AnimationProvider>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.onInitialize(this);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class TabControllerProvider extends StatefulWidget {
  final Widget child;
  final Function(TickerProvider vsync) onInitialize;

  const TabControllerProvider({
    Key? key,
    required this.child,
    required this.onInitialize,
  }) : super(key: key);

  @override
  State<TabControllerProvider> createState() => _TabControllerProviderState();
}

class _TabControllerProviderState extends State<TabControllerProvider>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.onInitialize(this);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
