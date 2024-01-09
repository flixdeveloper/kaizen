import 'package:flutter/material.dart';
import 'package:kaizen/menu_item.dart';

class MenuItems extends StatefulWidget {
  const MenuItems({super.key});

  @override
  State<MenuItems> createState() => _MenuItems();
}

class _MenuItems extends State<MenuItems> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final MenuItem itemSignOut = MenuItem('Sign Out', icon: Icon(Icons.logout));
    final MenuItem itemDeletAccount = MenuItem.fromText(
        text: Text(
          "Delete Account",
          style: TextStyle(color: Colors.red),
        ),
        icon: Icon(Icons.delete, color: Colors.red));
    //final itemDarkMode = MenuItem("Dark Mode", icon: Icon(Icons.dark_mode));

    return Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            //itemDarkMode.buildItem(),
            //const Divider(
            //  thickness: 0.1,
            //),
            itemSignOut.buildItem(),
            const Divider(
              thickness: 0.1,
            ),
            itemDeletAccount.buildItem(),
          ],
        ));
  }
}
