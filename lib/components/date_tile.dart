import 'package:flutter/material.dart';

class DateTile extends StatelessWidget {
  final List<DateTime> dates;

  const DateTile({
    super.key,
    required this.dates,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListTile(
          contentPadding: EdgeInsets.only(left: 16.0, right: 8.0),
          trailing: Wrap(
            children: [
              for (final date in dates) ...[
                SizedBox(
                  width: 48,
                  height: 48,
                  child: Center(
                    child: Text(
                      '${_getShortWeekday(date.weekday)}\n${date.day}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ]
            ],
          ),
        );
      }
    );
  }
  
  String _getShortWeekday(int weekday) {
    switch (weekday) {
      case 1: return 'Mon';
      case 2: return 'Tue';
      case 3: return 'Wed';
      case 4: return 'Thu';
      case 5: return 'Fri';
      case 6: return 'Sat';
      case 7: return 'Sun';
      default: return '';
    }
  }
}

