import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kaizen/home_widget.dart';

class ArticleView extends StatefulWidget {
  final HomeWidget widget;
  const ArticleView(this.widget, {super.key});
  @override
  State<ArticleView> createState() => _ArticleView(widget.title,
      widget.subTitle, widget.type, widget.details, widget.background);
}

class _ArticleView extends State<ArticleView>
    with SingleTickerProviderStateMixin {
  final String title;
  final String? subTitle;
  final String type;
  String details;
  final String background;
  _ArticleView(
      this.title, this.subTitle, this.type, this.details, this.background);

  @override
  Widget build(BuildContext context) {
    details = details.replaceAll(r'\n', '\n');
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      //refresh the states of Parent from ModalBottomSheet in flutter
      return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                    aspectRatio: 15 / 9,
                    child: Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: background,
                        fit: BoxFit.cover,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
                  child: Column(
                    children: [
                      Text(title,
                          style: const TextStyle(
                            fontSize: 32,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 15),
                      Text(
                        details,
                        style: const TextStyle(
                          fontSize: 21,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ));
    });
  }
}
