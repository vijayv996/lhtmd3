import 'package:analog_timer/analog_timer.dart';
import 'package:flutter/material.dart';
import 'package:lhtmd3/pages/habits_page.dart';
import 'package:lhtmd3/pages/heatmap_habits_page.dart';
import 'package:lhtmd3/pages/pomodoro_page.dart';
import 'package:lhtmd3/pages/settings_page.dart';
import 'dart:io';
import 'package:lhtmd3/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  WidgetsFlutterBinding.ensureInitialized();

  final databaseService = DatabaseService();
  final userExists = await databaseService.userExists();

  if(!userExists) {
    await databaseService.createDefaultUser();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LHTMD3',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 22, 53, 12), brightness: Brightness.dark),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int currentPageIndex = 0;
  bool isCommitView = false;
  late AnalogTimerController _pomodoroController;
  final Future<SharedPreferencesWithCache> _prefsWithCache =
      SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(
          allowList: <String>{'commitView'},
        ),
      );

  late final List<Widget> _pages;
  
  @override
  void initState() {
    super.initState();
    _pomodoroController = AnalogTimerController(duration: Duration(minutes: 25));
    _pomodoroController.initializeAnimation(this);
    _loadHomePagePreferences();

    _pages = [
      isCommitView ? HeatmapHabitsPage(toggleHomePage: toggleHomePage) : Habits(toggleHomePage: toggleHomePage),
      Pomodoro(controller: _pomodoroController),
      Settings(),
    ];
  }

  void _loadHomePagePreferences() async {
    final prefsWithCache = await _prefsWithCache;
    setState(() {
      isCommitView = prefsWithCache.getBool('commitView') ?? false;
    });
    // Rebuilds the page if view changes
    _pages[0] = isCommitView ? HeatmapHabitsPage(toggleHomePage: toggleHomePage) : Habits(toggleHomePage: toggleHomePage);
  }

  void toggleHomePage() async {
    final prefsWithCache = await _prefsWithCache;
    
    setState(() {
      isCommitView = !isCommitView;
      prefsWithCache.setBool('commitView', isCommitView);
      _pages[0] = isCommitView ? HeatmapHabitsPage(toggleHomePage: toggleHomePage) : Habits(toggleHomePage: toggleHomePage);
    });
  }

  @override
  void dispose() {
    _pomodoroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Theme.of(context).colorScheme.primaryContainer,
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.check_box),
            icon: Icon(Icons.check_box_outlined),
            label: 'Habits',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.timer),
            icon: Icon(Icons.timer_outlined),
            label: 'Pomodoro',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings_applications),
            icon: Icon(Icons.settings_applications_outlined),
            label: 'Settings',
          )
        ]
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: _pages,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
    );
  }
}
