import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:one_clock/one_clock.dart';
import 'package:provider/provider.dart';
import 'package:raysystem_flutter/api/api.dart';
import 'package:raysystem_flutter/card/card_manager.dart';
import 'package:raysystem_flutter/form/form_field.dart';
import 'package:raysystem_flutter/form/form_manager.dart';
import 'package:screen_capturer/screen_capturer.dart';
import 'package:raysystem_flutter/component/ocr_card.dart';
import 'package:raysystem_flutter/main.dart';

Map<String, dynamic> commands = {
  'commands': [
    {
      'command': 'settings-app',
      'title': '设置',
      'icon': Icons.settings,
      'commands': [
        {
          'command': 'toggle-theme',
          'title': '切换主题',
          'icon': Icons.brightness_medium,
          'callback': (BuildContext context, CardManager cardManager) {
            final themeNotifier =
                Provider.of<ThemeNotifier>(context, listen: false);
            themeNotifier.toggleTheme();
          },
        },
      ],
    },
    {
      'command': 'text-app',
      'icon': Icons.text_fields,
      'title': '文本处理',
      'commands': [
        {
          'command': 'ocr-region',
          'title': 'OCR 识别区域',
          'icon': Icons.crop,
          'callback': (BuildContext context, CardManager cardManager) async {
            print('OCR 识别区域');
            CapturedData? captureData =
                await ScreenCapturer.instance.capture(mode: CaptureMode.region);
            if (captureData != null) {
              final result = await api.recognizeTextOcrRecognizePost(
                file: MultipartFile.fromBytes(
                  captureData.imageBytes!,
                  filename: 'capture.png',
                ),
              );

              cardManager.addCard(OcrCard(
                imageBytes: captureData.imageBytes!,
                ocrText: result.data?.asMap['text'] ?? '',
              ));
            }
          },
        },
        {
          'command': 'ocr-full',
          'title': 'OCR 识别全屏',
          'icon': Icons.fullscreen,
          'callback': (BuildContext context, CardManager cardManager) async {
            print('OCR 识别全屏');
            CapturedData? captureData =
                await ScreenCapturer.instance.capture(mode: CaptureMode.screen);
            if (captureData != null) {
              final result = await api.recognizeTextOcrRecognizePost(
                file: MultipartFile.fromBytes(
                  captureData.imageBytes!,
                  filename: 'capture.png',
                ),
              );

              cardManager.addCard(OcrCard(
                imageBytes: captureData.imageBytes!,
                ocrText: result.data?.asMap['text'] ?? '',
              ));
            }
          },
        },
        {
          'command': 'ocr-window',
          'title': 'OCR 识别窗口',
          'icon': Icons.desktop_windows,
          'callback': (BuildContext context, CardManager cardManager) async {
            print('OCR 识别窗口');
            CapturedData? captureData =
                await ScreenCapturer.instance.capture(mode: CaptureMode.window);
            if (captureData != null) {
              final result = await api.recognizeTextOcrRecognizePost(
                file: MultipartFile.fromBytes(
                  captureData.imageBytes!,
                  filename: 'capture.png',
                ),
              );

              cardManager.addCard(OcrCard(
                imageBytes: captureData.imageBytes!,
                ocrText: result.data?.asMap['text'] ?? '',
              ));
            }
          },
        },
      ]
    },
    {
      'command': 'note-app',
      'title': '笔记应用',
      'icon': Icons.note,
      'commands': [
        {
          'command': 'note-add',
          'title': '添加笔记',
          'icon': Icons.add,
          'callback': (BuildContext context, CardManager cardManager) {
            print('添加笔记');
          }
        },
        {
          'command': 'note-list',
          'title': '查看笔记',
          'icon': Icons.list,
          'callback': (BuildContext context, CardManager cardManager) {
            print('查看笔记');
          }
        },
        {
          'command': 'note-delete',
          'title': '删除笔记',
          'icon': Icons.delete,
          'callback': (BuildContext context, CardManager cardManager) {
            print('删除笔记');
          }
        }
      ]
    },
    {
      'command': 'todo-app',
      'title': '待办事项应用',
      'icon': Icons.check,
      'commands': [
        {
          'command': 'todo-add',
          'title': '添加待办事项',
          'icon': Icons.add,
          'callback': (BuildContext context, CardManager cardManager) {
            print('添加待办事项');
          }
        },
        {
          'command': 'todo-list',
          'title': '查看待办事项',
          'icon': Icons.list,
          'callback': (BuildContext context, CardManager cardManager) {
            print('查看待办事项');
          }
        },
        {
          'command': 'todo-delete',
          'title': '删除待办事项',
          'icon': Icons.delete,
          'callback': (BuildContext context, CardManager cardManager) {
            print('删除待办事项');
          }
        },
        {
          'command': 'todo-more',
          'title': '更多操作',
          'icon': Icons.more_horiz,
          'commands': [
            {
              'command': 'todo-more-1',
              'title': '更多操作1',
              'icon': Icons.more_horiz,
              'callback': (BuildContext context, CardManager cardManager) {
                print('更多操作1');
              }
            },
            {
              'command': 'todo-more-2',
              'title': '更多操作2',
              'icon': Icons.more_horiz,
              'callback': (BuildContext context, CardManager cardManager) {
                print('更多操作2');
              }
            }
          ]
        }
      ]
    },
    {
      'command': 'playground-app',
      'title': '游乐场',
      'icon': Icons.play_arrow,
      'commands': [
        {
          'command': 'digital-clock',
          'title': '数字时钟',
          'icon': Icons.watch_later,
          'callback': (BuildContext context, CardManager cardManager) {
            print('数字时钟');
            cardManager.addCard(DigitalClock(
              digitalClockTextColor:
                  Theme.of(context).textTheme.bodyLarge!.color!,
              isLive: true,
            ));
          }
        },
        {
          'command': 'analog-clock',
          'title': '模拟时钟',
          'icon': Icons.watch,
          'callback': (BuildContext context, CardManager cardManager) {
            print('模拟时钟');
            cardManager.addCard(AnalogClock(
              width: 200,
              height: 200,
              isLive: true,
            ));
          }
        },
        {
          'command': 'who-am-i',
          'title': '我是谁',
          'icon': Icons.face,
          'callback': (BuildContext context, CardManager cardManager) async {
            print('我是谁');

            final result = await FormManager.showForm(
              context: context,
              title: '我是谁',
              fields: [
                RSFormField(
                  label: '姓名',
                  id: 'name',
                  type: FieldType.text,
                ),
                RSFormField(
                  id: 'gender',
                  label: '性别',
                  type: FieldType.dropdown,
                  options: ['男', '女'],
                  defaultValue: '男',
                ),
              ],
            );

            if (result == null) {
              return;
            }

            cardManager.addCard(Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('姓名: ${result['name']}'),
                  Text('性别: ${result['gender']}')
                ],
              ),
            ));
          }
        },
        {
          'command': 'backend-hello-world',
          'title': 'API Hello World',
          'icon': Icons.cloud,
          'callback': (BuildContext context, CardManager cardManager) async {
            print('API Hello World');

            final result = await api.heeloWorldHelloGet();

            cardManager.addCard(Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(result.data.toString()),
            ));
          }
        }
      ]
    },
    {
      'command': 'info-app',
      'title': '资讯',
      'icon': Icons.article,
      'commands': [
        {
          'command': 'info-list',
          'title': '资讯列表',
          'icon': Icons.list_alt,
          'callback': (BuildContext context, CardManager cardManager) async {
            print('获取资讯列表');
            final result = await api.getInfosInfosGet(
                limit: 10, createdBefore: DateTime.now().toUtc());

            cardManager.addCard(Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '最新资讯',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ...result.data!.items
                      .map(
                        (info) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(info.title),
                              subtitle: info.description != null
                                  ? Text(
                                      info.description!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : null,
                              trailing: info.isNew
                                  ? const Chip(
                                      label: Text('NEW'),
                                      backgroundColor: Colors.red,
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                    )
                                  : null,
                              onTap: () {
                                // TODO: 打开资讯详情
                              },
                            ),
                            if (info != result.data!.items.last)
                              const Divider(),
                          ],
                        ),
                      )
                      .toList(),
                  if (result.data!.hasMore)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            // TODO: 加载更多
                          },
                          child: const Text('加载更多'),
                        ),
                      ),
                    ),
                ],
              ),
            ));
          }
        },
      ]
    },
  ]
};
