import 'package:flutter/material.dart';

class Rounded extends StatefulWidget {
  final Widget child;
  final double vertical;
  final double horizontal;
  final double round;
  final Color? color;
  const Rounded(this.child, this.vertical, this.horizontal,
      {super.key, this.round = 10, this.color});
  @override
  State<Rounded> createState() => _Rounded();
}

class _Rounded extends State<Rounded> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: widget.color ?? Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.all(Radius.circular(widget.round))),
        child: Material(
          color: Colors.transparent,
          child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: widget.vertical, horizontal: widget.horizontal),
              child: widget.child),
        ));
  }
}
