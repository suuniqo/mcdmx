import 'package:flutter/material.dart';
import 'package:mcdmx/style/format.dart';

import 'package:mcdmx/domain/line.dart';
import 'package:mcdmx/domain/station.dart';
import 'package:mcdmx/style/network.dart';

class Bgcard extends StatelessWidget {
  final Station station;

  final TextStyle? style;
  final Line line;
  final bool foward;
  final ThemeData theme;

  Bgcard({
    required this.station,
    required this.foward,
    required this.line,
    required this.theme,
    this.style,
  });

  int doyHoras(int total){
    return total~/60;
  }

  @override
  Widget build(BuildContext context) {
    Direction direction = line.forwardDir;
    DateTime now = direction.line.network!.nowRemote();    // segundo

    if (!foward) {
      direction = line.backwardDir;
    }

    int nextArrival = direction.nextArrivalDuration(station, now).inMinutes;
    now = DateTime.now().add(Duration(minutes:nextArrival));
    int nextArrival2=direction.nextArrivalDuration(station, now).inMinutes;
    now = DateTime.now().add(Duration(minutes:nextArrival2));
    int nextArrival3 = direction.nextArrivalDuration(station, now).inMinutes;

    return Card(
      margin: EdgeInsets.zero,
      elevation: Format.elevation,
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(Format.marginCard),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(direction.name, style: style),
                SizedBox(width: 5),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Image.asset(NetworkStyle.fromLine(line)),
                ),
              ],
            ),
            SizedBox(width: 5),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(nextArrival<60)...[
                Text(
                  "$nextArrival min",
                  style: style,
                ),
                ]
                else...[
                  if(nextArrival-60*doyHoras(nextArrival)==0)
                  Text(
                  "${doyHoras(nextArrival)} h",
                  style: style,)
                  else
                  Text(
                  "${doyHoras(nextArrival)} h ${nextArrival-60*doyHoras(nextArrival)} min",
                  style: style,)
                ],
                SizedBox(width: 17),
                if(nextArrival+nextArrival2<60)...[
                Text(
                  "${nextArrival+nextArrival2} min",
                  style: style,
                ),
                ]
                else...[
                  if(nextArrival+nextArrival2-60*doyHoras(nextArrival+nextArrival2)==0)
                  Text(
                  "${doyHoras(nextArrival+nextArrival2)} h",
                  style: style,)
                  else
                  Text(
                  "${doyHoras(nextArrival+nextArrival2)} h ${nextArrival+nextArrival2-60*doyHoras(nextArrival+nextArrival2)} min",
                  style: style,)
                ],
                SizedBox(width: 17),
                if(nextArrival+nextArrival2+nextArrival3<60)...[
                Text(
                  "${nextArrival+nextArrival2+nextArrival3} min",
                  style: style,
                ),
                ]
                else...[
                  if(nextArrival+nextArrival2+nextArrival3-60*doyHoras(nextArrival+nextArrival2+nextArrival3)==0)
                  Text(
                  "${doyHoras(nextArrival+nextArrival2+nextArrival3)} h",
                  style: style,)
                  else
                  Text(
                  "${doyHoras(nextArrival+nextArrival2+nextArrival3)} h ${nextArrival+nextArrival2+nextArrival3-60*doyHoras(nextArrival+nextArrival2+nextArrival3)} min",
                  style: style,)
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
