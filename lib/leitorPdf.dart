import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LeitorPdf extends StatefulWidget {
  @override
  _LeitorPdfState createState() => _LeitorPdfState();
}

class _LeitorPdfState extends State<LeitorPdf> {
  var _links = 'https://drive.google.com/open?id=1LeFp8f7_rfpT5GgK0uRarnI10Zta0FTL';
  final _key = UniqueKey();
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Programação Da Reunião"),
        ),
        body: Column(
          children: [
            Expanded(
                child: WebView(
                     
                    key: _key,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: _links))
          ],
        ));
  }
}
