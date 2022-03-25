import 'dart:async';

import 'package:flutter/material.dart';

class RandomOpacity extends StatefulWidget {
  const RandomOpacity({
    required this.child,
    this.duration = const Duration(milliseconds: 250),
    this.isAlwaysVisible = false,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final Duration duration;
  final bool isAlwaysVisible;

  @override
  State<RandomOpacity> createState() => _RandomOpacityState();
}

class _RandomOpacityState extends State<RandomOpacity> {
  bool _isVisible = false;

  Future<void> _startTimer() async {
    if (!widget.isAlwaysVisible && !_isVisible) {
      Timer(widget.duration, () {
        if (mounted) {
          setState(() {
            _isVisible = true;
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  PreferredSizeWidget asPreferredSizeWidget() {
    assert(widget.child is PreferredSizeWidget);

    return _OpacityPreferredSize(
      preferredSize: (widget.child as PreferredSizeWidget).preferredSize,
      child: widget.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.isAlwaysVisible || _isVisible ? 1 : 0,
      duration: const Duration(milliseconds: 250),
      child: widget.child,
    );
  }
}

class _OpacityPreferredSize extends AppBar {
  _OpacityPreferredSize({
    required Size preferredSize,
    required this.child,
  }) : _preferredSize = preferredSize;

  final Size _preferredSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
