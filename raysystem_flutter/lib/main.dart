import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raysystem_flutter/card/card_list_view.dart';
import 'package:raysystem_flutter/card/card_manager.dart';
import 'package:raysystem_flutter/commands.dart';
import 'package:raysystem_flutter/component/status_bar.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CardManager(maxCards: 20)),
      ChangeNotifierProvider(create: (_) => ThemeNotifier()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // 黑客风格的亮色主题 - 低饱和度版本
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Color(0xFF466D54), // 更深、更灰的绿色
      primaryContainer: Color(0xFF35523F), // 深灰绿色用于强调
      secondary: Color(0xFF587668), // 灰青绿色
      tertiary: Color(0xFF6B8C7D), // 柔和的灰绿色
      surface: Color(0xFFF7F9F8), // 极淡的灰绿色
      background: Color(0xFFFCFDFC), // 近白色，带一点灰绿
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF2F3B35), // 深灰绿色文字
      onBackground: Color(0xFF2F3B35),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF466D54),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: Color(0xFFF7F9F8),
      elevation: 2,
      shadowColor: Color(0xFF466D54).withOpacity(0.2),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF587668),
        foregroundColor: Colors.white,
        elevation: 1,
        shadowColor: Color(0xFF466D54).withOpacity(0.2),
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF2F3B35)),
      bodyMedium: TextStyle(color: Color(0xFF2F3B35)),
    ),
    iconTheme: IconThemeData(
      color: Color(0xFF466D54),
    ),
  );

  // 赛博朋克风格的暗色主题
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF00FFFF), // 霓虹青色
      primaryContainer: Color(0xFF0D3D3D), // 深青色
      secondary: Color(0xFFFF00FF), // 霓虹粉色
      tertiary: Color(0xFFFF1493), // 深粉色
      surface: Color(0xFF1A1A2E), // 深蓝黑色
      background: Color(0xFF0A0A1E), // 更深的蓝黑色
      error: Color(0xFFFF0000), // 鲜艳的红色
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Color(0xFF00FFFF), // 霓虹青色文字
      onBackground: Color(0xFFE6E6FA), // 淡紫色文字
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1A1A2E),
      foregroundColor: Color(0xFF00FFFF),
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: Color(0xFF1E1E32), // 稍亮的深蓝黑色
      elevation: 8,
      shadowColor: Color(0xFF00FFFF).withOpacity(0.2),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF0D3D3D),
        foregroundColor: Color(0xFF00FFFF),
        elevation: 5,
        shadowColor: Color(0xFF00FFFF).withOpacity(0.5),
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFE6E6FA)),
      bodyMedium: TextStyle(color: Color(0xFFE6E6FA)),
    ),
    iconTheme: IconThemeData(
      color: Color(0xFF00FFFF),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: 'Stream-like Card Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<List<Map<String, dynamic>>> _commandStack = [];

  @override
  void initState() {
    super.initState();
    _commandStack.add(commands['commands']);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      // appBar: AppBar(
      //   title: const Text('流式卡片 Demo'),
      // ),
      body: Column(
        children: [
          StatusBar(
            left: [
              StatusBarItem(child: Text('Demo Mode')),
              StatusBarItem(
                  child: Text(
                      'Cards: ${context.watch<CardManager>().cards.length}')),
            ],
            center: [
              StatusBarItem(child: Text('RaySystem')),
            ],
            right: [
              StatusBarItem(
                  child: Text(DateTime.now().toString().substring(0, 19))),
            ],
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: const CardListView(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color:
              isDark ? theme.colorScheme.surface : theme.colorScheme.background,
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? theme.colorScheme.primary.withOpacity(0.1)
                  : theme.colorScheme.primary.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, -2),
            )
          ],
        ),
        padding: const EdgeInsets.all(8.0),
        child: _buildBottomPanel(context),
      ),
    );
  }

  Widget _buildBottomPanel(BuildContext context) {
    if (_commandStack.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentCommands = _commandStack.last;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ...currentCommands.map((cmd) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ElevatedButton.icon(
                onPressed: () {
                  if (cmd.containsKey('commands')) {
                    final List<dynamic>? subCmds = cmd['commands'];
                    if (subCmds != null) {
                      setState(() {
                        _commandStack
                            .add(List<Map<String, dynamic>>.from(subCmds));
                      });
                    }
                  } else if (cmd['callback'] != null) {
                    cmd['callback'](
                      context,
                      Provider.of<CardManager>(context, listen: false),
                    );
                  }
                },
                icon: Icon(
                  cmd['icon'] as IconData?,
                  size: 20,
                ),
                label: Text(
                  cmd['title']?.toString() ?? '无标题',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }),
          if (_commandStack.length > 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _commandStack.removeLast();
                  });
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: isDark
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onPrimary,
                ),
                label: Text(
                  '返回',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class MySampleCard extends StatefulWidget {
  final String uniqueId;
  const MySampleCard({super.key, required this.uniqueId});

  @override
  State<MySampleCard> createState() => _MySampleCardState();
}

class _MySampleCardState extends State<MySampleCard> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Card ID: ${widget.uniqueId}'),
      subtitle: Text('当前计数: $_counter'),
      onTap: () {
        setState(() {
          _counter++;
        });
      },
    );
  }
}

class ThemeNotifier extends ChangeNotifier {
  bool isDarkMode = false;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}
