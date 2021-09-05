import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Terms extends StatefulWidget {
  Terms({Key key}) : super(key: key);

  @override
  _TermsState createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'https://faceclubofficial.blogspot.com/p/privacy.html',
    );
  }
}
