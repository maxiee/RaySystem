import 'package:flutter/material.dart';
import 'package:raysystem_flutter/component/card/ray_card.dart';

class SearchPeopleCard extends StatefulWidget {
  const SearchPeopleCard({super.key});

  @override
  State<SearchPeopleCard> createState() => _SearchPeopleCardState();
}

class _SearchPeopleCardState extends State<SearchPeopleCard> {
  @override
  Widget build(BuildContext context) {
    return RayCard(content: Container());
  }
}
