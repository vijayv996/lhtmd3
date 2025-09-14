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
      title: 'Flutter Demo',
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

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;
  bool isCommitView = false;
  
  @override
  void initState() {
    super.initState();
    homePagePreferenceHelper();
  }

  void homePagePreferenceHelper() async {
    // on first launch create commitView pref and sets it to false 
    final SharedPreferencesWithCache prefsWithCache = 
      await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(
          allowList: <String>{'commitView'},
        ),
      );
    
    if(prefsWithCache.getBool('commitView') == null) {
      prefsWithCache.setBool('commitView', isCommitView);
    }

    // no appbar the above code wont matter and the preference will be toggled
    setState(() {
      isCommitView = !isCommitView;
      prefsWithCache.setBool('commitView', isCommitView);
    });
  }

  Widget _getCurrentHomePage() {
    return isCommitView ? HeatmapHabitsPage(toggleHomePage: homePagePreferenceHelper,) : Habits(toggleHomePage: homePagePreferenceHelper,);
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
      body: [
        _getCurrentHomePage(),
        Pomodoro(),
        Settings(),
      ][currentPageIndex],
      backgroundColor: theme.scaffoldBackgroundColor,
    );
  }
}