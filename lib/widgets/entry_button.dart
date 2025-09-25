import 'package:flutter/material.dart';
import 'package:lhtmd3/models/habit.dart';
import 'package:lhtmd3/models/habit_entry.dart';
import 'package:lhtmd3/services/database.dart';

class EntryButton extends StatefulWidget {
  const EntryButton({
    super.key,
    required this.habitType,
    required this.habitId,
    this. measurementUnits,
    required this.entry,
    required this.date,
    required this.onEntryUpdate,
  });

  final HabitType habitType;
  final int habitId;
  final String? measurementUnits;
  final HabitEntry? entry;
  final DateTime date;
  final Function(HabitEntry) onEntryUpdate;

  @override
  State<EntryButton> createState() => _EntryButtonState();
}

class _EntryButtonState extends State<EntryButton> {
  final _valueController = TextEditingController();

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: 48,
      child: widget.habitType == HabitType.yesNo
        ? IconButton(onPressed: () async {
          final databaseService = DatabaseService();
          final existingEntry = widget.entry;
          double newValue;
          if(existingEntry != null) {
            if(existingEntry.value == 0) {
              newValue = 1;
            } else if(existingEntry.value == 1) {
              newValue = 2;
            } else {
              newValue = 1;
            }
          } else {
            newValue = 1;
          }
          final newentry = HabitEntry(
            entryId: widget.entry?.entryId,
            habitId: widget.habitId,
            entryDate: widget.date,
            value: newValue
          );
          await databaseService.insertEntry(newentry);
          widget.onEntryUpdate(newentry);
        }, icon: _getIconForEntry(widget.entry?.value))
        : TextButton(
          onPressed: () {
            final databaseService = DatabaseService();
            showDialog(
              context: context, 
              builder: (context) {
                return AlertDialog(
                  title: Text('Enter Value: '),
                  content: TextField(
                    controller: _valueController,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'value',
                    ),
                    autofocus: true,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      }, 
                      child: Text('CANCEL')
                    ),
                    FilledButton(
                      onPressed: () async {
                        final newentry = HabitEntry(
                          entryId: widget.entry?.entryId,
                          habitId: widget.habitId,
                          entryDate: widget.date,
                          value: double.parse(_valueController.text),
                        );
                        Navigator.pop(context);
                        await databaseService.insertEntry(newentry);
                        widget.onEntryUpdate(newentry);
                      },
                      child: Text('OK')
                    ),
                  ],
                );
              },
            );
          }, 
          child: widget.entry?.value == null
          ? FittedBox(
            child: Text(
              '0\n${widget.measurementUnits}',
              textAlign: TextAlign.center,
              softWrap: false,
              style: TextStyle(
                fontSize: 10,
                fontFamily: 'Roboto Mono',
              ),
            ),
          )
          : FittedBox(
            child: Text(
              '${widget.entry!.value.toString()}\n${widget.measurementUnits}',
              textAlign: TextAlign.center,
              softWrap: false,
              style: TextStyle(
                fontSize: 10,
                fontFamily: 'Roboto Mono',
              ),
            ),
          )
        ),
    );
  }
}

Widget _getIconForEntry(double? value) {
  IconData icon = Icons.close;
  if(value == 0 || value == null) icon = Icons.close;
  if(value == 1) icon = Icons.check;
  if(value == 2) icon = Icons.remove;
  return Icon(icon);
}
