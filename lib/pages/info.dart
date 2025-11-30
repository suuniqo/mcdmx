import 'package:flutter/material.dart';

import 'package:mcdmx/domain/line.dart';

import 'package:mcdmx/domain/station.dart';

import 'package:mcdmx/widgets/bgcard.dart';
import 'package:mcdmx/widgets/bigcard.dart';

import 'package:mcdmx/style/format.dart';
import 'package:mcdmx/style/network.dart';


class LineButton extends StatelessWidget {
  final Line line;
  final bool foward;

  const LineButton({super.key, required this.line, required this.foward});

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
              MaterialPageRoute(builder: (context) => LinesPage(line: line, foward: foward)),
            );
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Format.borderRadius),
            ),
            backgroundColor: Colors.amber,
          ),
          child: Padding(
            padding: const EdgeInsets.all(Format.marginCard),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 30, height: 30, child: Image.asset(NetworkStyle.fromLine(line))),
                SizedBox(width: 12),
                if (foward) Text(line.forwardDir.name, style: styleName),
                if (!foward) Text(line.backwardDir.name, style: styleName),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
            backgroundColor: Colors.amber,
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
  final Line line;
  final bool foward;

  const LinesPage({required this.line, required this.foward});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Iterable<Station> paradas = line.forwardDir.stations;
    if (!foward) {
      paradas = line.backwardDir.stations;
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            if (foward) Text(line.forwardDir.name),
            if (!foward) Text(line.backwardDir.name),
            SizedBox(width: 30, height: 30, child: Image.asset(NetworkStyle.fromLine(line))),
          ],
        ),
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
            child: SingleChildScrollView(
              child: Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(Format.marginCard),
                  child: Column(
                    children: [
                      for (var stop in paradas)
                        StationButton(
                          dst: StationsPage(
                            station: stop,
                            lineas: stop.lines,
                            lineaPage: true,
                            linea: line,
                            foward: foward,
                          ),
                          station: stop,
                          lines: stop.lines,
                        ),
                    ],
                  ),
                ),
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
  final Iterable<Line> lineas;
  final bool lineaPage;
  final Line? linea;
  final bool? foward;

  const StationsPage({
    required this.station,
    required this.lineas,
    required this.lineaPage,
    this.linea,
    this.foward,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final styleSubTitle = TextStyle(
      fontSize: 15,
      color: theme.colorScheme.onSurface,
    );
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            Text(station.name, style: styleSubTitle),
            SizedBox(width: 5),
            SizedBox(width: 30, height: 30, child: Image.asset(NetworkStyle.fromStation(station))),
            if (station.accesible) ...[
              SizedBox(width: 5),
              SizedBox(width: 30, height: 30, child: Icon(Icons.accessible_rounded)),
            ],
          ],
        ),
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
            child: SingleChildScrollView(
              child: Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(Format.marginCard),
                  child: Column(
                    children: [
                      if (lineaPage) ...[
                        Bigcard(title: "Tiempo Real"),
                        for (var line in lineas) ...[
                          SizedBox(height: 5),
                          Bgcard(
                            station: station,
                            line: line,
                            foward: true,
                            style: styleSubTitle,
                          ),
                          SizedBox(height: 5),
                          Bgcard(
                            station: station,
                            line: line,
                            foward: false,
                            style: styleSubTitle,
                          ),
                        ],
                      ],
                      if (!lineaPage && linea != null && foward != null) ...[
                        Bigcard(title: "Tiempo Real"),
                        SizedBox(height: 5),
                        Bgcard(
                          station: station,
                          line: linea!,
                          foward: foward!,
                          style: styleSubTitle,
                        ),
                        Bigcard(title: "Otros Andenes de ${station.name}"),
                        SizedBox(height: 5),
                        Bgcard(
                          station: station,
                          line: linea!,
                          foward: foward!,
                          style: styleSubTitle,
                        ),
                        for (var line in lineas.where((l) => l != linea)) ...[
                          SizedBox(height: 5),
                          Bgcard(
                            station: station,
                            line: line,
                            foward: true,
                            style: styleSubTitle,
                          ),
                          SizedBox(height: 5),
                          Bgcard(
                            station: station,
                            line: line,
                            foward: false,
                            style: styleSubTitle,
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
