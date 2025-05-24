import 'package:flutter/material.dart';
import 'package:raysystem_flutter/commands/command.dart';
import 'package:raysystem_flutter/module/people/cards/people_card/people_card.dart';
import 'package:raysystem_flutter/module/people/cards/search_people/search_people_card.dart';
import 'package:raysystem_flutter/module/people/cards/recent_people/recent_people_card.dart';

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
          // 添加人物搜索卡片
          cardManager.addCard(SearchPeopleCard(), wrappedInRayCard: false);
        },
      ),
      Command(
        command: 'people-recent',
        title: '最近添加',
        icon: Icons.history,
        callback: (context, cardManager) {
          // 添加最近人物卡片
          cardManager.addCard(RecentPeopleCard(), wrappedInRayCard: false);
        },
      ),
      Command(
          command: 'people-add',
          title: '添加人物',
          icon: Icons.add,
          callback: (context, cardManager) {
            // 添加人物卡片
            cardManager.addCard(PeopleCard(), wrappedInRayCard: false);
          }),
      Command(
          command: 'people-recent',
          title: '最近联系人',
          icon: Icons.access_time,
          callback: (context, cardManager) {
            // 添加最近联系人卡片
            cardManager.addCard(RecentPeopleCard(), wrappedInRayCard: false);
          }),
    ]);
