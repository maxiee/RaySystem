import 'package:flutter/material.dart';
import 'package:raysystem_flutter/commands/command.dart';
import 'package:raysystem_flutter/module/people/cards/people_card/people_card.dart';
import 'package:raysystem_flutter/module/people/cards/search_people/search_people_card.dart';

final peopleCommands = Command(
    command: 'people-app',
    title: '人物',
    icon: Icons.people,
    subCommands: [
      Command(
        command: 'people-search',
        title: '找人',
        icon: Icons.search,
        callback: (context, cardManager) {
          // 添加人物列表卡片
          cardManager.addCard(SearchPeopleCard(), wrappedInRayCard: false);
        },
      ),
      Command(
          command: 'people-add',
          title: '添加人物',
          icon: Icons.add,
          callback: (context, cardManager) {
            // 添加人物列表卡片
            cardManager.addCard(PeopleCard(), wrappedInRayCard: false);
          }),
    ]);
