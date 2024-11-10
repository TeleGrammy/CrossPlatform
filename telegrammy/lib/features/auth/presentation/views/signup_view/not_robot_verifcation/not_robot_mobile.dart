// webview_mobile.dart
import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

Widget createWebView(Function(String) onTokenReceived) {
  return SizedBox(
    height: 100,
    child: WebViewPlus(
      backgroundColor: Colors.transparent,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (controller) async {
        await controller.loadUrl("assets/webpages/index.html");
      },
      javascriptChannels: {
        JavascriptChannel(
            name: 'Captcha',
            onMessageReceived: (JavascriptMessage message) {
              onTokenReceived(
                  message.message); // Pass the token to the callback
              var captchaToken = message.message; //captcha token
              print(captchaToken);
            })
      },
    ),
  );
}
