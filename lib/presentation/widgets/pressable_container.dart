import 'package:flutter/material.dart';

class PressableContainer extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Decoration? decoration;
  final List<BoxShadow>? boxShadow;
  final double pressOffset;
  final Duration pressDuration;
  final Duration releaseDuration;

  const PressableContainer({
    super.key,
    required this.child,
    required this.onPressed,
    this.margin,
    this.padding,
    this.decoration,
    this.boxShadow,
    this.pressOffset = 6.0,
    this.pressDuration = const Duration(milliseconds: 90),
    this.releaseDuration = const Duration(milliseconds: 40),
  });

  @override
  State<PressableContainer> createState() => _PressableContainerState();
}

class _PressableContainerState extends State<PressableContainer> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    BoxDecoration? effectiveDecoration;
    
    if (widget.decoration != null && widget.decoration is BoxDecoration) {
      final boxDec = widget.decoration as BoxDecoration;
      effectiveDecoration = BoxDecoration(
        color: boxDec.color,
        border: boxDec.border,
        borderRadius: boxDec.borderRadius,
        gradient: boxDec.gradient,
        image: boxDec.image,
        boxShadow: _pressed ? [] : (widget.boxShadow ?? boxDec.boxShadow),
        shape: boxDec.shape,
      );
    } else if (widget.decoration != null) {
      effectiveDecoration = widget.decoration as BoxDecoration?;
    } else {
      effectiveDecoration = BoxDecoration(
        boxShadow: _pressed ? [] : widget.boxShadow,
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) async {
        await Future.delayed(widget.pressDuration);
        if (!mounted) return;
        setState(() => _pressed = false);
        await Future.delayed(widget.releaseDuration);
        if (!mounted) return;
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: widget.pressDuration,
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _pressed ? widget.pressOffset : 0, 0),
        margin: widget.margin,
        padding: widget.padding,
        decoration: effectiveDecoration,
        child: widget.child,
      ),
    );
  }
}
