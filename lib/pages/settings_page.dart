import 'package:flutter/material.dart';
import 'package:lhtmd3/services/database.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});
  @override
  Widget build(BuildContext context) {
    final databaseService = DatabaseService();
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Reset the app'),
              onTap: databaseService.deleteDatabase,
            ),
            ListTile(
              leading: Icon(Icons.backup),
              title: Text('Backup Data'),
              onTap: () => databaseService.backupDatabase(),
            ),
            ListTile(
              leading: Icon(Icons.restore),
              title: Text('Restore Data'),
              onTap: () => databaseService.restoreDatabase(),
            ),
          ],
        ),
      ),
    );
  }
}
