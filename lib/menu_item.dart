import 'package:flutter/material.dart';

class MenuItem {
  final Text text;
  final Widget icon;

  MenuItem(String text, {required this.icon}) : this.text = Text(text);

  MenuItem.fromText({
    required this.text,
    required this.icon,
  });

  Widget buildItem() {
    return InkWell(
        child: Row(
      children: [
        text,
        Spacer(),
        icon,
      ],
    ));
  }
}
