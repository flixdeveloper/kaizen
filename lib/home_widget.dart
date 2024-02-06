import 'package:auto_direction/auto_direction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kaizen/article_page.dart';
import 'package:kaizen/audio_page.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kaizen/video_page.dart';
import 'package:kaizen/web_view_page.dart';

part 'home_widget.g.dart';

@JsonSerializable()
class HomeWidget {
  //int id = UniqueKey().hashCode;
  String title;
  String? subTitle;
  String type;
  String details;
  String background;

  HomeWidget(this.title, this.type, this.details, this.background);

  void homeWidgetClick(BuildContext context) {
    if (type == "link") {
      launchUrl(context);
    } else if (type == "article") {
      navigateArticle(context);
    } else if (type == "video" || type == "youtube") {
      navigateVideo(context);
    } else if (type == "audio") navigateAudio(context);
  }

  void navigateArticle(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (contetxt) => ArticleView(title, details, background),
      ),
    );
  }

  void navigateVideo(BuildContext context) {
    //context.
    //context.setLocale(Locale('en'));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (contetxt) => VideoPage(type == "video", details),
      ),
    ); //.then((_) => context.setLocale(Locale('he')));
  }

  void navigateAudio(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (contetxt) => AudioPlayer(this),
      ),
    );
  }

  Future<void> launchUrl(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => openWebView(context, details),
      ),
    );
  }

  Widget getWidget(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: AspectRatio(
            aspectRatio: 15 / 9,
            child: GestureDetector(
                onTap: () => homeWidgetClick(context),
                child: CachedNetworkImage(
                    //make this image support flow widget, i want to set delegate: ParallaxFlowDelegate dart?
                    imageUrl: background,
                    imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(
                                    0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Visibility(
                              visible: title != '',
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(),
                                    Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black.withOpacity(0.11),
                                              Colors.black.withOpacity(0.75)
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            stops: const [0.57, 0.95],
                                          ),
                                          //color: Theme.of(context)
                                          //    .colorScheme
                                          //    .onPrimary
                                          //    .withOpacity(0.5),
                                          borderRadius: const BorderRadius.only(
                                            bottomRight: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            AutoDirection(
                                                text: title,
                                                child: Text(title,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontFamily: 'Lato',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ))),
                                            const SizedBox(height: 10),
                                            Visibility(
                                                visible: subTitle != null,
                                                child: AutoDirection(
                                                  text: subTitle ?? "",
                                                  child: Text(
                                                    subTitle ?? "",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                )),
                                          ],
                                        ))
                                  ])),
                        ),
                    placeholder: (context, url) => Container(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover))));
  }

  /// Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory HomeWidget.fromJson(Map<String, dynamic> json) =>
      _$HomeWidgetFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$HomeWidgetToJson(this);
}
