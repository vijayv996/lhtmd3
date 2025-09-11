import 'package:flutter/material.dart';
import 'package:lhtmd3/services/database.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement settings
    final databaseService = DatabaseService();
    return ListTile(
      leading: Icon(Icons.delete),
      title: Text('Reset the app'),
      onTap: databaseService.deleteDatabase,
    );
  }
}