import 'package:flutter/material.dart';
import 'package:mcdmx/style/format.dart';

import 'package:mcdmx/domain/line.dart';
import 'package:mcdmx/domain/station.dart';
import 'package:mcdmx/style/logos.dart';

class Bgcard extends StatelessWidget {
  final Station station;

  final TextStyle? style;
  final Color? color;
  final Line line;
  final bool foward;

  Bgcard({
    required this.station,
    required this.foward,
    required this.line,
    this.style,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    Direction direction = line.forwardDir;
    DateTime now = DateTime.now();

    if (!foward) {
      direction = line.backwardDir;
    }

    int nextArrival = direction.nextArrivalDuration(station, now).inMinutes;

    return Card(
      margin: EdgeInsets.zero,
      elevation: Format.elevation,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(Format.marginCard),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(station.name, style: style),
                SizedBox(width: 12),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Image.asset(Logos.fromStation(station)),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$nextArrival min",
                  style: style,
                ),
                SizedBox(width: 12),
                Text(
                  "${nextArrival + line.trainFreq} min",
                  style: style,
                ),
                SizedBox(width: 12),
                Text(
                  "${nextArrival + 2*line.trainFreq} min",
                  style: style,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
