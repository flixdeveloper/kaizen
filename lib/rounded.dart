import 'package:flutter/material.dart';

//make a function with a parameter that i can sign or autosign if i dont write anything?
Widget Rounded(
    Widget child, BuildContext context, double vertical, double horizontal,
    {double round = 10, Color? color}) {
  return Container(
      decoration: BoxDecoration(
          color: color ?? Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.all(Radius.circular(round))),
      child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
          child: child));
}
