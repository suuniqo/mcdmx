import 'package:flutter/material.dart';

import 'package:mcdmx/domain/line.dart';

import 'package:mcdmx/domain/station.dart';
import 'package:mcdmx/style/content.dart';

import 'package:mcdmx/style/format.dart';
import 'package:mcdmx/style/network.dart';


class StationButton extends StatelessWidget {
  final Station station;
  final Widget dst;
  final Iterable<Line> lines;
  const StationButton({
    super.key,
    required this.dst,
    required this.station,
    required this.lines,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final styleName = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.onSurface,
    );

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => dst),
            );
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Format.borderRadius),
            ),
            backgroundColor:theme.colorScheme.surfaceContainerLow,
          ),
          child: Padding(
            padding: const EdgeInsets.all(Format.marginCard),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset(NetworkStyle.fromStation(station)),
                ),
                SizedBox(width: 12),
                Text(station.name, style: styleName),
                SizedBox(width: 12),
                for (var line in lines)
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.asset(NetworkStyle.fromLine(line)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LinesPage extends StatelessWidget {
  final Direction dir;

  const LinesPage({required this.dir});

  Widget _buildDirStations(BuildContext context) {
    final theme = Theme.of(context);
    final content = ContentStyle.fromTheme(theme);

    return Padding(
      padding: const EdgeInsets.all(Format.marginPrimary),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                NetworkStyle.fromLine(dir.line),
                height: 37,
                width: 37,
              ),
              SizedBox(width: 14,),
              Text(
                dir.name.split('-')[0].split(' ')[0],
                style: content.titleTertiary,
              ),
              Icon(Icons.arrow_right_rounded),
              Text(
                dir.name.split('-')[1].split(' ')[0],
                style: content.titleTertiary,
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Divider(color: theme.colorScheme.surfaceTint, thickness: 2),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (final station in dir.stations)
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => StationsPage(station: station))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Image.asset(
                                  NetworkStyle.fromStation(station),
                                  height: 40,
                                  width: 40,
                                ),
                                if (station != dir.stations.last)
                                  Container(
                                    width: 3,
                                    height: 20,
                                    color: NetworkStyle.lineColor(dir.line),
                                  )
                              ],
                            ),
                            SizedBox(width: Format.marginPrimary,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        station.name,
                                        style: content.titleItem,
                                      ),
                                      Spacer(),
                                      Row(
                                        children: [
                                          for (final line in station.lines)
                                            Padding(
                                              padding: const EdgeInsets.only(right: 4.0),
                                              child: Image.asset(
                                                NetworkStyle.fromLine(line),
                                                height: 16,
                                                width: 16,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(station.accesible ? Icons.accessible_rounded : Icons.not_accessible_rounded, size: 15),
                                      SizedBox(width: 4,),
                                      Text(station.accesible ? 'Accesible' : 'No accesible'),
                                    ],
                                  ),
                                  if (station != dir.stations.last)
                                    Divider(color: theme.colorScheme.surfaceTint, thickness: 2),
                                ]
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Línea'),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
          fontSize: 22,
        ),
        backgroundColor: theme.colorScheme.surface,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Format.marginPrimary),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Format.borderRadius),
            ),
            clipBehavior: Clip.antiAlias,
            child: Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(Format.marginCard),
                child: _buildDirStations(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StationsPage extends StatelessWidget {
  final Station station;

  const StationsPage({required this.station});

  Widget _buildTimeLines(BuildContext context) {
    final theme = Theme.of(context);
    final content = ContentStyle.fromTheme(theme);

    final dirs = station.lines.expand((line) => [line.forwardDir, line.backwardDir]);

    return Padding(
      padding: const EdgeInsets.all(Format.marginPrimary),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                NetworkStyle.fromStation(station),
                height: 47,
                width: 47,
              ),
              SizedBox(width: Format.marginPrimary,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          station.name.split(' ')[0],
                          style: content.titleTertiary,
                        ),
                        Spacer(),
                        Row(
                          children: [
                            for (final line in station.lines)
                              Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: Image.asset(
                                  NetworkStyle.fromLine(line),
                                  height: 18,
                                  width: 18,
                                ),
                              ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(station.accesible ? Icons.accessible_rounded : Icons.not_accessible_rounded, size: 15),
                        SizedBox(width: 4,),
                        Text(station.accesible ? 'Accesible' : 'No accesible'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Divider(color: theme.colorScheme.surfaceTint, thickness: 2),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (final dir in dirs)
                    Material(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Image.asset(
                              NetworkStyle.fromLine(dir.line),
                              height: 34,
                              width: 34,
                            ),
                          ),
                          SizedBox(width: Format.marginPrimary,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      dir.name.split('-')[0].split(' ')[0],
                                      style: content.titleItem,
                                    ),
                                    Icon(Icons.arrow_right_rounded, size: 16,),
                                    Text(
                                      dir.name.split('-')[1].split(' ')[0],
                                      style: content.titleItem,
                                    ),
                                  ],
                                ),
                                _buildNextArrivals(dir),
                                if (dir != dirs.last)
                                  Divider(color: theme.colorScheme.surfaceTint, thickness: 2),
                              ]
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextArrivals(Direction dir) {
    final now = DateTime.now();

    final firstDuration = dir.nextArrivalDuration(station, now);
    final firstDate = now.add(firstDuration);

    final secondDuration = dir.nextArrivalDuration(station, firstDate);
    final secondDate = firstDate.add(secondDuration);

    final thirdDuration = dir.nextArrivalDuration(station, secondDate);
    final thirdDate = secondDate.add(thirdDuration);

    final first = firstDuration;
    final second = secondDate.difference(now);
    final third = thirdDate.difference(now);

    return Row(
      children: [
        Text(
          '${first.inHours > 0 ? '${first.inHours} h' : ''} '
          '${first.inMinutes > 0 ? '${first.inMinutes % 60} min' : ''}', 
        ),
        SizedBox(width: 16,),
        Text(
          '${second.inHours > 0 ? '${second.inHours} h' : ''} '
          '${second.inMinutes > 0 ? '${second.inMinutes % 60} min' : ''}', 
        ),
        SizedBox(width: 16,),
        Text(
          '${third.inHours > 0 ? '${third.inHours} h' : ''} '
          '${third.inMinutes > 0 ? '${third.inMinutes % 60} min' : ''}', 
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Tiempo real'),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
          fontSize: 22,
        ),
        backgroundColor: theme.colorScheme.surface,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Format.marginPrimary),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Format.borderRadius),
            ),
            clipBehavior: Clip.antiAlias,
            child: Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(Format.marginCard),
                child: _buildTimeLines(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
