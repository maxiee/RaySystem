import 'package:flutter/material.dart';
import 'package:one_clock/one_clock.dart';
import 'package:raysystem_flutter/api/api.dart'; // 添加这一行
import 'package:raysystem_flutter/commands/command.dart';
// Import the note tree card
import 'package:raysystem_flutter/form/form_field.dart';
import 'package:raysystem_flutter/form/form_manager.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:dio/dio.dart'; // 新增 dio 导入
import 'package:raysystem_flutter/component/card/ray_card.dart'; // 新增 RayCard 导入

final playgroundCommands = Command(
  command: 'playground-app',
  title: '游乐场',
  icon: Icons.play_arrow,
  subCommands: [
    Command(
      command: 'digital-clock',
      title: '数字时钟',
      icon: Icons.watch_later,
      callback: (context, cardManager) {
        cardManager.addCard(DigitalClock(
          digitalClockTextColor: Theme.of(context).textTheme.bodyLarge!.color!,
          isLive: true,
        ));
      },
    ),
    Command(
      command: 'analog-clock',
      title: '模拟时钟',
      icon: Icons.watch,
      callback: (context, cardManager) {
        cardManager.addCard(AnalogClock(
          width: 200,
          height: 200,
          isLive: true,
        ));
      },
    ),
    Command(
      command: 'who-am-i',
      title: '我是谁',
      icon: Icons.face,
      callback: (context, cardManager) async {
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
      },
    ),
    Command(
      command: 'backend-hello-world',
      title: 'API Hello World',
      icon: Icons.cloud,
      callback: (context, cardManager) async {
        final result = await api.heeloWorldHelloGet();
        cardManager.addCard(Container(
          padding: const EdgeInsets.all(8.0),
          child: Text(result.data.toString()),
        ));
      },
    ),
    Command(
      command: 'appflowy-editor',
      title: '富文本编辑器',
      icon: Icons.edit_document,
      callback: (context, cardManager) {
        final editorState = EditorState.blank();
        final editorScrollController =
            EditorScrollController(editorState: editorState);
        cardManager.addCard(
          Container(
            padding: const EdgeInsets.all(8.0),
            height: 400,
            width: double.infinity,
            child: FloatingToolbar(
              items: [
                paragraphItem,
                ...headingItems,
                ...markdownFormatItems,
                quoteItem,
                bulletedListItem,
                numberedListItem,
                linkItem,
                buildTextColorItem(),
                buildHighlightColorItem(),
                ...textDirectionItems,
                ...alignmentItems
              ],
              textDirection: TextDirection.ltr,
              editorState: editorState,
              editorScrollController: editorScrollController,
              child: AppFlowyEditor(
                editorState: editorState,
                editorScrollController: editorScrollController,
                shrinkWrap: true,
              ),
            ),
          ),
        );
      },
    ),
    Command(
      command: 'debug-weibo-image',
      title: '调试微博图片',
      icon: Icons.image,
      callback: (context, cardManager) async {
        const imageUrl =
            'https://wx1.sinaimg.cn/mw690/87860e4bgy1i17cvs1w1aj20of0swdjc.jpg'; // 请替换为实际的微博图片 URL
        final dio = Dio();
        try {
          final response = await dio.get(
            imageUrl,
            options: Options(
              responseType: ResponseType.bytes, // 获取原始字节数据
              headers: {
                'Referer': 'https://weibo.com',
                'User-Agent':
                    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36',
                'sec-fetch-mode': 'no-cors',
                'sec-fetch-site': 'cross-site',
              },
            ),
          );

          if (response.statusCode == 200 && response.data != null) {
            cardManager.addCard(
              RayCard(
                title: const Text('微博图片'),
                content: Image.memory(response.data),
              ),
              wrappedInRayCard: false, // RayCard 内部已经处理了包裹
            );
          } else {
            cardManager.addCard(Container(
              padding: const EdgeInsets.all(8.0),
              child: Text('图片加载失败: ${response.statusCode}'),
            ));
          }
        } catch (e) {
          cardManager.addCard(Container(
            padding: const EdgeInsets.all(8.0),
            child: Text('图片加载异常: $e'),
          ));
        }
      },
    ),
  ],
);
