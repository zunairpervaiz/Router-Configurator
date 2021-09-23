import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Router Config',
      theme: ThemeData.dark(),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const menuItems = <String>[
    "192.168.0.1",
    "192.168.1.1",
    "192.168.10.1"
  ];
  final List<DropdownMenuItem<String>> dropDownMenuItem =
      menuItems.map((String e) {
    return DropdownMenuItem<String>(
      value: e,
      child: Text(e),
    );
  }).toList();
  String dropDownValue;
  WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Router Config"),
          actions: [
            IconButton(
                icon: Icon(CupertinoIcons.power),
                onPressed: () {
                  exit(0);
                })
          ],
          bottom: PreferredSize(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: dropDownValue,
                          style: TextStyle(color: Colors.white),
                          items: dropDownMenuItem,
                          hint: Text("Select Router",
                              style: TextStyle(color: Colors.white)),
                          iconEnabledColor: Colors.white,
                          onChanged: (String value) {
                            setState(() {
                              dropDownValue = value;
                              _webViewController
                                  .loadUrl("http://$dropDownValue");
                              print(dropDownValue);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            preferredSize: Size.fromHeight(56),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: WebView(
            gestureNavigationEnabled: true,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
          ),
        ));
  }
}
