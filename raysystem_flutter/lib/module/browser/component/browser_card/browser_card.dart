import 'package:flutter/material.dart';
import 'package:raysystem_flutter/module/browser/component/browser_window/browser_window.dart';

class BrowserCard extends StatefulWidget {
  const BrowserCard({super.key});

  @override
  State<BrowserCard> createState() => _BrowserCardState();
}

class _BrowserCardState extends State<BrowserCard> {
  @override
  Widget build(BuildContext context) {
    return BrowserWindow(initialUrl: 'https://baidu.com');
  }
}
