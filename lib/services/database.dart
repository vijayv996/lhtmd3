import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:lhtmd3/models/habit.dart';
import 'package:lhtmd3/models/habit_entry.dart';
import 'package:lhtmd3/models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if(_database != null) return _database!;
    _database = await _initDatabse();
    return _database!;
  }

  Future<Database> _initDatabse() async {
    WidgetsFlutterBinding.ensureInitialized();

    return openDatabase(
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
  }

  Future<bool> userExists() async {
    final db = await database;
    final result = await db.query('user');
    return result.isNotEmpty;
  }

  Future<void> createDefaultUser() async {
    final user = User(
      userId: 1,
      username: 'Default User',
    );
    await insertUser(user);
  }

  Future<void> insertUser(User user) async {
    final db = await database;

    await db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<User>> getUsers() async {
    final db = await database;

    final List<Map<String, Object?>> userMaps = await db.query('user');
    return [
      for (final {'user_id': userId as int, 'username': username as String} in userMaps)
        User(userId: userId, username: username),
    ];
  }
  
  Future<void> insertHabit(Habit habit) async {
    final db = await database;

    await db.insert(
      'habits',
      habit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<Habit>> getHabits(int userId) async {
    final db = await database;

    final List<Map<String, Object?>> habitMaps = await db.query(
      'habits',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return [
      for (final {
            'habit_id': habitId as int,
            'user_id': userId as int,
            'habit_name': habitName as String,
            'habit_type': habitType as String,
            'measurement_unit': measurementUnit as String?,
          } in habitMaps)
        Habit(
          habitId: habitId,
          userId: userId,
          habitName: habitName,
          habitType: HabitType.values.firstWhere((e) => e.toString().split('.').last == habitType),
          measurementUnit: measurementUnit,
        ),
    ];
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