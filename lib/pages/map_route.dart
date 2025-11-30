import 'package:flutter/material.dart';
import 'package:mcdmx/domain/station.dart';
import 'package:mcdmx/state/network.dart';
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
  bool _isOpen = false;

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

  Widget _buildOpenTile(BuildContext context, List<Station> stations) {
    final theme = Theme.of(context);
    final contentStyle = ContentStyle.fromTheme(theme);

    return Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            icon: Icon(
              Icons.close_rounded,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            children: [
              SizedBox(height: 8),
              Text('Estaciones del trayecto', style: contentStyle.titleTertiary),
            ],
          ),
        ),
      ],
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
          'LLegarás en ${duration.inHours > 0 ? '${duration.inHours} h' : ''} ${duration.inMinutes > 0 ? '${duration.inMinutes} min' : ''}', 
          style: contentStyle.titleTertiary
        ),
        Text(
          'Desliza para ver las estaciones de la ruta',
          style: contentStyle.descItem,
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


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final network = context.watch<NetworkState>();

    final (route, time) = network.calculateRoute(widget._src, widget._dst);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SlidingUpPanel(
            defaultPanelState: _isOpen ? PanelState.OPEN : PanelState.CLOSED,
            onPanelOpened: () {
              setState(() => _isOpen = true);
            },
            onPanelClosed: () {
              setState(() => _isOpen = false);
            },
            parallaxEnabled: true,
            parallaxOffset: 0.5,
            maxHeight: constraints.maxHeight * 0.94,
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
                          _buildOpenTile(context, route),
                          SizedBox(height: Format.marginPrimary),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Stack(
              children: [
                MapRoute(route),
                _buildCloseX(context)]
              ),
            borderRadius: BorderRadius.circular(Format.borderRadius),
          );
        },
      ),
    );
  }
}
