import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raysystem_flutter/card/card_list_view.dart';
import 'package:raysystem_flutter/card/card_manager.dart';
import 'package:raysystem_flutter/commands.dart';
import 'package:raysystem_flutter/component/status_bar.dart';
import 'package:raysystem_flutter/component/system_metrics_provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CardManager(maxCards: 20)),
      ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ChangeNotifierProvider(create: (_) => SystemMetricsProvider()),
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

  // EVA inspired cyberpunk dark theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Color(0xFFFF6600), // EVA 标志性橙色
      primaryContainer: Color(0xFF2D1D15), // 深橙色容器
      secondary: Color(0xFF00FF00), // NERV 界面特征的荧光绿
      tertiary: Color(0xFFAE00FF), // 初号机风格的紫色
      surface: Color(0xFF1A1A2A), // 深蓝紫色表面
      background: Color(0xFF0A0A16), // NERV 总部风格的深色背景
      error: Color(0xFFFF0033), // 警告红色
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Color(0xFF00FF00), // 终端风格的荧光绿文字
      onBackground: Color(0xFFE6E6FA), // 浅紫色文字
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF0A0A16),
      foregroundColor: Color(0xFFFF6600),
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: Color(0xFF1E1E32), // MAGI 界面风格的深色
      elevation: 8,
      shadowColor: Color(0xFFFF6600).withOpacity(0.3),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF2D1D15),
        foregroundColor: Color(0xFFFF6600),
        elevation: 5,
        shadowColor: Color(0xFFFF6600).withOpacity(0.4),
      ),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: Color(0xFFFF6600),
        shadows: [
          Shadow(
            color: Color(0xFFFF6600).withOpacity(0.5),
            blurRadius: 8,
          ),
        ],
      ),
      bodyLarge: TextStyle(color: Color(0xFF00FF00)),
      bodyMedium: TextStyle(color: Color(0xFFE6E6FA)),
    ),
    iconTheme: IconThemeData(
      color: Color(0xFFFF6600),
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

    return Container(
      width: double.infinity,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ...currentCommands.map((cmd) {
            return SizedBox(
              height: 32, // 固定按钮高度
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
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
                  size: 16,
                ),
                label: Text(
                  cmd['title']?.toString() ?? '无标题',
                  style: TextStyle(fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }),
          if (_commandStack.length > 1)
            SizedBox(
              height: 32, // 返回按钮也使用相同的固定高度
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _commandStack.removeLast();
                  });
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 16,
                  color: isDark
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onPrimary,
                ),
                label: Text(
                  '返回',
                  style: TextStyle(fontSize: 13),
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
