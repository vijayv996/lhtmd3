import 'package:flutter/material.dart';

class Habits extends StatelessWidget {
  const Habits({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // call with an empty text and only dates
        // we write a for loop with text, and state of each date tile
        HabitTile(),
        HabitTile()
      ],
    );
  }
}

class HabitTile extends StatefulWidget {
  const HabitTile({
    super.key,
  });

  @override
  State<HabitTile> createState() => _HabitTileState();
}


// claude 
class _HabitTileState extends State<HabitTile> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double availableWidth = constraints.maxWidth;
        int maxIcons = ((availableWidth - 200) / 45).floor().clamp(1, 100);
        
        return ListTile(
          title: Text('test'),
          leading: Icon(Icons.incomplete_circle),
          trailing: Wrap(
            // spacing: 10,
            children: [
              for (int i = 0; i < maxIcons; i++) ...[
                IconButton(
                  onPressed: () {}, 
                  icon: Icon(Icons.remove),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
