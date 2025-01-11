import 'package:flutter/widgets.dart';

class CardItem {
  final GlobalKey _key;
  final Widget Function(GlobalKey key) builder;

  CardItem({
    required GlobalKey key,
    required this.builder,
  }) : _key = key;

  GlobalKey get key => _key;
}
