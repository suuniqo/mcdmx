import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:mcdmx/style/network.dart';

import 'package:provider/provider.dart';

import 'package:latlong2/latlong.dart';

import 'package:mcdmx/state/network.dart';
import 'package:mcdmx/state/scheme.dart';


class MapCDMX extends StatelessWidget {
  static const LatLng defaultCoords = LatLng(
    19.430017555308567,
    -99.13440962985258,
  );

  @override
  Widget build(BuildContext context) {
    final scheme = context.watch<SchemeState>();
    final network = context.watch<NetworkState>();

    final theme = Theme.of(context);

    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(initialCenter: defaultCoords),
          children: [
            TileLayer(
              urlTemplate: scheme.isDarkMode
                  ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                  : 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
              userAgentPackageName: 'com.example.mcdmx',
            ),
            PolylineLayer(
              polylines: [
                for (final line in network.lines)
                  Polyline(
                    strokeWidth: 5,
                    color: NetworkStyle.lineColor(line),
                    points: [
                      for (final station in line.forwardDir.stations)
                        station.coords
                    ]
                  ),
              ],
            ),
            MarkerLayer(
              markers: [
                for (final station in network.stations)
                  Marker(
                    point: station.coords,
                    child: Image.asset(NetworkStyle.fromStation(station)),
                  )
              ]
            ),
          ],
        ),
        IgnorePointer(
          ignoring: true,
          child: Container(
            color: theme.colorScheme.primary.withValues(alpha: scheme.isDarkMode ? 0.02 : 0.04),
          ),
        ),
      ],
    );
  }
}
