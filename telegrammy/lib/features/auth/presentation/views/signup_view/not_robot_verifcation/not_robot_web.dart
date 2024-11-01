// webview_web.dart
import 'package:flutter/widgets.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:ui_web' as ui;

Widget createWebView(Function(String) onTokenReceived) {
  //ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory('web-view', (int viewId) {
    final html.IFrameElement element = html.IFrameElement();
    element.src = 'assets/webpages/index.html';
    element.style.border = 'none';
    return element;
  });

  // Listen for messages from JavaScript
  html.window.onMessage.listen((html.MessageEvent event) {
    onTokenReceived(event.data); // Call the callback with the received data
  });

  return HtmlElementView(viewType: 'web-view');
}
