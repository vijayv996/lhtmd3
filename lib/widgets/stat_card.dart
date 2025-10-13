import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final String? yesterdayValue;
  final int fontSize;
  final bool? isTodayLower;

  const StatCard({
    super.key,
    required this.title,
    required this.subTitle,
    this.yesterdayValue,
    this.fontSize = 24,
    this.isTodayLower,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            if (yesterdayValue != null && isTodayLower != null)
              Row(
                children: [
                  Text(
                    yesterdayValue!,
                    style: const TextStyle(fontSize: 10,),
                  ),
                  isTodayLower! 
                  ? Icon(
                    Icons.arrow_downward,
                    size: 10,
                    color: Colors.red,
                  )
                  : Icon(
                    Icons.arrow_upward,
                    size: 10,
                    color: Colors.green,
                  )
                ],
              ),
            const Spacer(),
            Text(
              subTitle,
              style: TextStyle(
                fontSize: fontSize.toDouble(), 
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
