import 'dart:math';
import 'dart:ui' as ui;
import 'package:auto_direction/auto_direction.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide ReorderableList;
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

class Reorderable extends StatefulWidget {
  const Reorderable(this.items, {Key? key}) : super(key: key);
  final List<ItemData> items;

  @override
  _ReorderableState createState() => _ReorderableState();
}

class ItemData {
  ItemData(this.title, this.index) {
    this.title =
        (title.isNotEmpty && int.tryParse(title[title.length - 1]) != null)
            ? title.tr()
            : title;
    key = ValueKey(index);
  }
  int index;
  String title;

  // Each item in reorderable list needs stable and unique key
  late final Key key;
}

enum DraggingMode {
  iOS,
  android,
}

class _ReorderableState extends State<Reorderable>
    with SingleTickerProviderStateMixin {
  late List<ItemData> _items = widget.items;

  // Returns index of item with given key
  int _indexOfKey(Key key) {
    return _items.indexWhere((ItemData d) => d.key == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    // Uncomment to allow only even target reorder possition
    // if (newPositionIndex % 2 == 1)
    //   return false;

    final draggedItem = _items[draggingIndex];
    setState(() {
      debugPrint("Reordering $item -> $newPosition");
      _items.removeAt(draggingIndex);
      _items.insert(newPositionIndex, draggedItem);
    });
    return true;
  }

  void _reorderDone(Key item) {
    final draggedItem = _items[_indexOfKey(item)];
    debugPrint("Reordering finished for ${draggedItem.title}}");
  }

  //
  // Reordering works by having ReorderableList widget in hierarchy
  // containing ReorderableItems widgets
  //

  DraggingMode _draggingMode = DraggingMode.iOS;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: max(280, _items.length * 80 + 70),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Row(
              textDirection: ui.TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 35,
                ),
                ElevatedButton(
                    onPressed: () => {Navigator.of(context).pop(true)},
                    child: Text("save".tr())),
                SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                  radius: 15,
                  backgroundColor: Theme.of(context).colorScheme.onBackground,
                  child: IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    iconSize: 15,
                    onPressed: () {
                      var item = ItemData('', UniqueKey().hashCode);
                      textFieldPopup(isAdd: true, context, item.title)
                          .then((confirmed) => setState(() {
                                if (confirmed != null) {
                                  item.title = confirmed;
                                  _items.add(item);
                                }
                              }));
                      Feedback.forTap(context);
                    },
                  ),
                ),
              ],
            ),
            body: //Container(height: 10),
                Container(
                    height: max(228, _items.length * 80 + 18),
                    child: SingleChildScrollView(
                        child: Column(children: [
                      ReorderableList(
                        onReorder: _reorderCallback,
                        onReorderDone: _reorderDone,
                        child: SingleChildScrollView(
                          child: ListView.builder(
                              itemCount: _items.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      final item = _items[index];
                                      textFieldPopup(context, item.title)
                                          .then((confirmed) => setState(() {
                                                if (confirmed ==
                                                    false.toString()) {
                                                  if (_items.length > 1)
                                                    _items.removeAt(index);
                                                  else
                                                    item.title = '';
                                                } else if (confirmed != null) {
                                                  item.title = confirmed;
                                                }
                                              }));
                                      Feedback.forTap(context);
                                    },
                                    child: Item(
                                      data: _items[index],
                                      draggingMode: _draggingMode,
                                    ));
                              }),
                        ),
                      ),
                    ])))));
  }
}

Future<String?> textFieldPopup(BuildContext context, String data,
    {bool isAdd = false}) async {
  TextEditingController controller = TextEditingController();
  controller.text = data;

  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
            content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AutoDirection(
              text: data,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(hintText: "question"),
                onChanged: (str) {
                  setState(() {
                    data = str;
                  });
                },
              ),
            ),
            SizedBox(height: 11),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (!isAdd)
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .redAccent, //Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // Rounded edge
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(false.toString());
                      },
                      child: Text(
                        "delete".tr(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                if (!isAdd) const SizedBox(width: 20), /////////////////
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: (isAdd) ? 60 : 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.onSurface,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // Rounded edge
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(data);
                      },
                      child: Text(
                        "Save".tr(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )

            // if (isAdd)
            //   ElevatedButton(
            //       onPressed: () => {Navigator.of(context).pop(true)},
            //       child: Text("add".tr())),
            // if (!isAdd)
            //   ElevatedButton(
            //     style: ButtonStyle(
            //         backgroundColor:
            //             MaterialStateProperty.all<Color>(Colors.red)),
            //     onPressed: () => {Navigator.of(context).pop(true)},
            //     child: Text(
            //       "delete".tr(),
            //       style: TextStyle(color: Colors.white),
            //     ),
            //   ),
          ],
        ));
      });
    },
  );
}

class Item extends StatelessWidget {
  const Item({
    Key? key,
    required this.data,
    required this.draggingMode,
  }) : super(key: key);

  final ItemData data;
  final DraggingMode draggingMode;

  Widget _buildChild(BuildContext context, ReorderableItemState state) {
    BoxDecoration decoration;

    if (state == ReorderableItemState.dragProxy ||
        state == ReorderableItemState.dragProxyFinished) {
      // slightly transparent background white dragging (just like on iOS)
      decoration = BoxDecoration(color: Colors.white.withOpacity(0.1));
    } else {
      bool placeholder = state == ReorderableItemState.placeholder;
      decoration = BoxDecoration(
          //border: Border(
          //    top: isFirst && !placeholder
          //        ? Divider.createBorderSide(context) //
          //        : BorderSide.none,
          //    bottom: isLast && placeholder
          //        ? BorderSide.none //
          //        : Divider.createBorderSide(context)),
          color: placeholder ? null : Colors.transparent);
    }

    // For iOS dragging mode, there will be drag handle on the right that triggers
    // reordering; For android mode it will be just an empty container
    Widget dragHandle = draggingMode == DraggingMode.iOS
        ? ReorderableListener(
            child: Container(
              padding: const EdgeInsets.only(right: 18.0, left: 18.0),
              color: const Color(0x08000000),
              child: const Center(
                child: Icon(Icons.reorder, color: Color(0xFF888888)),
              ),
            ),
          )
        : Container();

    Widget content = Container(
      decoration: decoration,
      child: SafeArea(
          top: false,
          bottom: false,
          child: Opacity(
            // hide content for placeholder
            opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14.0, horizontal: 14.0),
                    child: Text(data.title,
                        style: Theme.of(context).textTheme.titleMedium),
                  )),
                  // Triggers the reordering
                  dragHandle,
                ],
              ),
            ),
          )),
    );

    // For android dragging mode, wrap the entire content in DelayedReorderableListener
    if (draggingMode == DraggingMode.android) {
      content = DelayedReorderableListener(
        child: content,
      );
    }

    return content;
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
        key: data.key, //
        childBuilder: _buildChild);
  }
}
