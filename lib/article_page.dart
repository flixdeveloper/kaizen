import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ArticleView extends StatefulWidget {
  final String title;
  final String details;
  final String backgroundUrl;
  const ArticleView(this.title, this.details, this.backgroundUrl)
      : super(key: null);

  @override
  State<StatefulWidget> createState() {
    return _ArticleView();
  }
}

class _ArticleView extends State<ArticleView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 15 / 9,
                child: CachedNetworkImage(
                  imageUrl: widget.backgroundUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  children: [
                    Text(widget.title,
                        style: const TextStyle(
                          fontSize: 32,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 15),
                    Text(
                      widget.details.replaceAll(r'\n', '\n'),
                      style: const TextStyle(
                        fontSize: 21,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50)
            ],
          ),
        ));
  }
}
