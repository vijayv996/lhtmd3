import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:lhtmd3/models/habit.dart';
import 'package:lhtmd3/models/habit_entry.dart';
import 'package:lhtmd3/models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = openDatabase(
    join(await getDatabasesPath(), 'lht.db'),
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE user(user_id INTEGER PRIMARY KEY, username TEXT)',
      );
      await db.execute(
        '''
        CREATE TABLE habits(
          habit_id INTEGER PRIMARY KEY,
          user_id INTEGER NOT NULL,
          habit_name TEXT NOT NULL,
          created_on INTEGER NOT NULL,
          habit_type TEXT NOT NULL,
          measurement_unit TEXT,
          FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE
        )
        ''',
      );
      await db.execute(
        '''
        CREATE TABLE habit_entries(
          entry_id INTEGER PRIMARY KEY,
          habit_id INTEGER NOT NULL,
          entry_date INTEGER NOT NULL,
          value REAL NOT NULL,
          FOREIGN KEY (habit_id) REFERENCES habit(habit_id) ON DELETE CASCADE
        )
        '''
      );
    },
    version: 1,
  );

  Future<void> insertUser(User user) async {
    final db = await database;

    await db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertHabit(Habit habit) async {
    final db = await database;

    await db.insert(
      'habits',
      habit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> insertEntry(HabitEntry entry) async {
    final db = await database;
    
    await db.insert(
      'habit_entries',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}