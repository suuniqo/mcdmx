import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:mcdmx/domain/line.dart';

import 'package:mcdmx/domain/station.dart';

import 'package:mcdmx/state/network.dart';

import 'package:mcdmx/widgets/bgcard.dart';
import 'package:mcdmx/widgets/bigcard.dart';
import 'package:mcdmx/widgets/tab_box.dart';
import 'package:mcdmx/widgets/titled_page.dart';

import 'package:mcdmx/style/format.dart';
import 'package:mcdmx/style/logos.dart';


class NetworkInfoPage extends StatelessWidget {
  const NetworkInfoPage({super.key});

  Widget _quickAccessTabs(BuildContext context, ThemeData theme) {
    // Datos de ejemplo
    final network = context.watch<NetworkState>();

    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Card(
          margin: EdgeInsets.zero,
          color: theme.colorScheme.surfaceContainerLowest,
          elevation: 0,
          child: TabBox(
            tabsData: [
              (
                Icons.directions_subway_filled_rounded,
                'Paradas',
                Center(
                  child: ListView(
                    children: [
                      for (var (i, station) in network.stations.indexed)
                        Padding(
                          padding: EdgeInsets.only(
                            top: i == 0 ? 0 : Format.marginPrimary,
                          ),
                          child: StationButton(
                            dst: StationsPage(
                              station: station,
                              lineas: station.lines,
                              lineaPage: false,
                            ),
                            station: station,
                            lines: station.lines,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              (
                Icons.timeline,
                'Lineas',
                Center(
                  child: ListView(
                    children: [
                      for (var (i, line) in network.lines.indexed)
                        Padding(
                          padding: EdgeInsets.only(
                            top: i == 0 ? 0 : Format.marginPrimary,
                          ),
                          child: Column(
                            children: [
                              LineButton(line: line, foward: true),
                              LineButton(line: line, foward: false),
                            ],
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: TitledPage(
        title: 'Metro',
        icon: Image.asset(
          'assets/images/logocdmx.png',
          width: 32,
          height: 32,
          fit: BoxFit.contain,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: Format.marginPrimary),
            _quickAccessTabs(context, theme),
          ],
        ),
      ),
    );
  }
}

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
              MaterialPageRoute(builder: (context) => Placeholder()),
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
                SizedBox(width: 30, height: 30, child: Image.asset(Logos.fromLine(line))),
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
                  child: Image.asset(Logos.fromStation(station)),
                ),
                SizedBox(width: 12),
                Text(station.name, style: styleName),
                for (var line in lines)
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.asset(Logos.fromLine(line)),
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
            SizedBox(width: 30, height: 30, child: Image.asset(Logos.fromLine(line))),
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
            SizedBox(width: 30, height: 30, child: Image.asset(Logos.fromStation(station))),
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
