import 'package:flutter/material.dart';
import 'package:lhtmd3/components/date_tile.dart';

class Habits extends StatelessWidget {
  const Habits({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // TODO: send dates list
        DateTile(),
        // TODO: write a for loop with text, and state of each date tile
        HabitTile(
          habitName: 'did not complete',
          habitStates: [0,1,0,1,2],
          habitToggle: () {},
        ),
        HabitTile(
          habitName: 'completed',
          habitStates: [0,1,2,1,2],
          habitToggle: () {},
        ),
        HabitTile(
          habitName: 'skipped',
          habitStates: [0,1,1,1,0],
          habitToggle: () {},
        ),
      ],
    );
  }
}

class HabitTile extends StatefulWidget {
  final String habitName;
  final List<int> habitStates;
  final VoidCallback habitToggle;

  const HabitTile({
    super.key,
    required this.habitName,
    required this.habitStates,
    required this.habitToggle,
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
        int maxIcons = ((constraints.maxWidth - 200) / 45).floor().clamp(1, 100);
        
        return ListTile(
          contentPadding: EdgeInsets.only(left: 16.0, right: 8.0),
          title: Text(widget.habitName),
          leading: Icon(Icons.incomplete_circle),
          trailing: Wrap(
            // spacing: 10,
            children: [
              for (int i = 0; i < maxIcons; i++) ...[
                SizedBox(
                  height: 48,
                  width: 48,
                  child: IconButton(
                    onPressed: () { setState(() {
                      // TODO: update the database & icon
                    }); }, 
                    icon: Icon(widget.habitStates[i] == 0 ? Icons.close : widget.habitStates[i] == 1 ? Icons.check : Icons.remove)
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
