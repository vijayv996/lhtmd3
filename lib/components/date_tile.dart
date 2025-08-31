import 'package:flutter/material.dart';

class DateTile extends StatelessWidget {
  const DateTile({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int maxIcons = ((constraints.maxWidth - 200) / 45).floor().clamp(1, 100);

        return ListTile(
          trailing: Wrap(
            children: [
              for (int i = 0; i < maxIcons; i++) ...[
                SizedBox(
                  width: 40, // Width of iconbutton? wtf
                  child: Text(
                    'Mon\n 24',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ]
            ],
          ),
        );
      }
    );
  }
}