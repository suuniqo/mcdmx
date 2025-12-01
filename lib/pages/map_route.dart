import 'package:flutter/material.dart';
import 'package:mcdmx/domain/line.dart';
import 'package:mcdmx/domain/station.dart';
import 'package:mcdmx/state/network.dart';
import 'package:mcdmx/state/routes.dart';
import 'package:mcdmx/style/network.dart';
import 'package:provider/provider.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:mcdmx/style/content.dart';
import 'package:mcdmx/style/format.dart';
import 'package:mcdmx/widgets/maps.dart';

class MapRoutePage extends StatefulWidget {
  final Station _src;
  final Station _dst;

  MapRoutePage(this._src, this._dst);

  @override
  State<MapRoutePage> createState() => _MapRoutePageState();
}

class _MapRoutePageState extends State<MapRoutePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<RoutesState>().pushRecent((widget._src, widget._dst));
    });
  }
  Widget _buildDragHandle(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 50,
      height: 5,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceTint,
        borderRadius: BorderRadius.circular(Format.borderRadius),
      ),
    );
  }

  Widget _buildOpenTile(BuildContext context, List<Station> stations, RoutesState routes, NetworkState network) {
    final theme = Theme.of(context);
    final contentStyle = ContentStyle.fromTheme(theme);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text('Cómo llegar', style: contentStyle.titleSecondary),
                Text('Estas viendo la ruta mas ${network.isAccesibleMode ? 'accesible' : 'rápida'}', style: contentStyle.titleItem.copyWith(fontWeight: FontWeight.normal)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClosedTitle(BuildContext context, int arrivalInMinutes) {
    final theme = Theme.of(context);
    final contentStyle = ContentStyle.fromTheme(theme);
    final duration = Duration(minutes: arrivalInMinutes);

    return Column(
      children: [
        SizedBox(height: 1.5 * Format.marginPrimary),
        Text(
          'Llegada en ${duration.inHours > 0 ? '${duration.inHours} h' : ''} ${duration.inMinutes > 0 ? '${duration.inMinutes % 60} min' : ''}', 
          style: contentStyle.titleTertiary
        ),
        Text(
          'Desliza para ver las estaciones',
          style: contentStyle.descItem
        ),
      ],
    );
  }

  Widget _buildCloseX(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(Format.marginPrimary),
        child: Align(
          alignment: Alignment.topLeft,
          child: GestureDetector(
            onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                boxShadow: Format.shadow,
                color: theme.colorScheme.surfaceContainerLow,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close_rounded,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _generateRouteMessage(NetworkState network, List<Station> stations, Station curr, int idx) {
    if (stations.length == 1) {
      return 'Ya estás en tu destino';
    }
    if (idx == stations.length - 1) {
      return 'Sal del tren y llegarás a tu destino';
    }

    Direction dirNext = network.dirBetweenStations(curr, stations[idx+1])!;

    if (idx == 0) {
      return 'Toma la línea ${dirNext.line.number} dirección ${dirNext.name.split('-').last}';
    }

    Direction dirPrev = network.dirBetweenStations(stations[idx-1], curr)!;

    if (dirPrev != dirNext) {
      return 'Toma la línea ${dirNext.line.number} dirección ${dirNext.name.split('-').last}';
    } else {
      return 'Continua en el tren';
    }
  }

  Widget _buildRouteLayout(BuildContext context, List<Station> stations) {
    final theme = Theme.of(context);
    final content = ContentStyle.fromTheme(theme);

    final network = context.read<NetworkState>();

    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          for (final (i, station) in stations.indexed)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Format.marginPrimary),
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

                      if (station != stations.last)
                        Container(
                          width: 3,
                          height: 20,
                          color: NetworkStyle.lineColor(network.dirBetweenStations(station, stations[i+1])!.line),
                        )
                    ],
                  ),
                  SizedBox(width: Format.marginPrimary,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          station.name,
                          style: content.titleItem,
                        ),
                        Text(_generateRouteMessage(network, stations, station, i)),
                        if (station != stations.last)
                          Divider(color: theme.colorScheme.surfaceTint, thickness: 2),
                      ]
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final network = context.watch<NetworkState>();
    final routes = context.watch<RoutesState>();

    final (route, time) = network.calculateRoute(widget._src, widget._dst);
    final duration = Duration(minutes: time);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SlidingUpPanel(
            defaultPanelState: PanelState.CLOSED,
            parallaxEnabled: true,
            parallaxOffset: 0.5,
            maxHeight: constraints.maxHeight * 0.75,
            minHeight: 150,
            boxShadow: Format.shadow,
            color: theme.colorScheme.surfaceContainerLow,
            collapsed: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(Format.borderRadius),
              ),
              child: Column(
                children: [
                  SizedBox(height: Format.marginPrimary),
                  _buildDragHandle(context),
                  SizedBox(height: Format.marginPrimary),
                  _buildClosedTitle(context, time),
                  SizedBox(height: Format.marginPrimary),
                ],
              ),
            ),
            panel: SafeArea(
              top: false,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(Format.borderRadius),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(Format.marginPrimary),
                      child: Column(
                        children: [
                          _buildDragHandle(context),
                          SizedBox(height: Format.marginPrimary),
                          _buildOpenTile(context, route, routes, network),
                        ],
                      ),
                    ),
                    _buildRouteLayout(context, route),
                    Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 20.0, top: 8.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      side: BorderSide(
                        color: theme.colorScheme.surfaceTint,
                        width: Format.borderWidth,
                      ),
                      iconSize: 24,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Format.borderRadius),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                    onPressed: () => routes.toggleFav((widget._src, widget._dst)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        children: [
                          Icon(routes.isFav((widget._src, widget._dst))
                            ? Icons.favorite_rounded
                            : Icons.favorite_outline_rounded,
                          ),
                          SizedBox(width: 8,),
                          Text('Guardar en favoritos', style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 16,
                          )),
                          SizedBox(width: 6,),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
        Text(
          '${duration.inHours > 0 ? '${duration.inHours} h' : ''} '
          '${duration.inMinutes > 0 ? '${duration.inMinutes % 60} min' : ''}', 
          style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
              fontSize: 21,
          ),
        ),
        SizedBox(width: 8,)
                ]
              ),
            ),
                  ],
                ),
              ),
            ),
            body: Stack(
              children: [
                MapRoute(route),
                _buildCloseX(context),
              ],
            ),
            borderRadius: BorderRadius.circular(Format.borderRadius),
          );
        },
      ),
    );
  }
}
