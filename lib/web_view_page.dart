import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

Widget openWebView(BuildContext context, String url) {
  final WebViewController controller =
      WebViewController.fromPlatformCreationParams(
          const PlatformWebViewControllerCreationParams());
  controller
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse(url));

  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    //refresh the states of Parent from ModalBottomSheet in flutter
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(child: WebViewWidget(controller: controller)
              //javascriptMode: JavascriptMode.unrestricted,
              //initialUrl: widget._url
              )
        ],
      ),
    );
  });
}
