import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:one_clock/one_clock.dart';
import 'package:raysystem_flutter/api/api.dart';
import 'package:raysystem_flutter/card/card_manager.dart';
import 'package:raysystem_flutter/form/form_field.dart';
import 'package:raysystem_flutter/form/form_manager.dart';
import 'package:screen_capturer/screen_capturer.dart';
import 'package:raysystem_flutter/component/ocr_card.dart';

Map<String, dynamic> commands = {
  'commands': [
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
    }
  ]
};
