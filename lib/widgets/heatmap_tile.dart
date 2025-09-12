import 'package:flutter/material.dart';
import 'package:lhtmd3/widgets/heat_map_widget.dart';

class HeatmapTile extends StatefulWidget {
  const HeatmapTile({
    super.key,
    required this.entryMap,
    required this.habitName,
  });

  final Map<DateTime, int> entryMap;
  final String habitName;

  @override
  State<HeatmapTile> createState() => _HeatmapTileState();
}

class _HeatmapTileState extends State<HeatmapTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Card(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      child: SizedBox(
                        height: 48,
                        width: 48,
                        child: Icon(Icons.fitness_center),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.habitName,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            'Did you go to gym today?',
                            style: Theme.of(context).textTheme.labelSmall,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Card(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  child: SizedBox(
                    height: 48,
                    width: 48,
                    child: IconButton(
                      onPressed: () {}, 
                      icon: Icon(Icons.check),
                    ),
                  ),
                )
              ],
            ),
            HeatMapWidget(
              entryMap: widget.entryMap, 
              showText: false, 
              size: 15
            ),
          ],
        ),
      ),
    );
  }
}