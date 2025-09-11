import 'package:flutter/material.dart';
import 'package:lhtmd3/pages/habits_page.dart';
import 'package:lhtmd3/pages/pomodoro_page.dart';
import 'package:lhtmd3/pages/settings_page.dart';
import 'dart:io';
import 'package:lhtmd3/services/database.dart';
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
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Habits'),
        actions: [
          IconButton(
            // TODO: implement sorting
            onPressed: () {}, 
            tooltip: 'Sort',
            icon: Icon(Icons.sort)
          ),
          Padding(
            padding: const EdgeInsets.only(right: 13),
            child: IconButton(
              // TODO: github heatmap like ui
              onPressed: () {}, 
              tooltip: 'graph view',
              icon: Icon(Icons.view_agenda)
            ),
          )
        ],
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Theme.of(context).colorScheme.primaryContainer,
        selectedIndex: currentPageIndex,
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(Icons.check_box),
            icon: Icon(Icons.check_box_outlined),
            label: 'Habits'
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.timer),
            icon: Icon(Icons.timer_outlined),
            label: 'Pomodoro'
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings_applications),
            icon: Icon(Icons.settings_applications_outlined),
            label: 'Settings'
          )
        ]
      ),
      body: [
        Habits(),
        Pomodoro(),
        Settings(),
      ][currentPageIndex],
      backgroundColor: theme.scaffoldBackgroundColor,
    );
  }
}