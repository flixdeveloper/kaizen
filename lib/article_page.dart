import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kaizen/home_widget.dart';

class ArticleView extends StatefulWidget {
  final HomeWidget homeWidget;
  const ArticleView(
    this.homeWidget,
  ) : super(key: null);

  @override
  State<StatefulWidget> createState() {
    return _ArticleView();
  }
}

class _ArticleView extends State<ArticleView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    String title = widget.homeWidget.title;
    String details = widget.homeWidget.details.replaceAll(r'\n', '\n');
    String backgroundUrl = widget.homeWidget.background;

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
                      imageUrl: backgroundUrl,
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
  }
}
