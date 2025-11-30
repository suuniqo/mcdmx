import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:mcdmx/domain/station.dart';
import 'package:mcdmx/style/format.dart';
import 'package:mcdmx/style/network.dart';

import 'package:provider/provider.dart';

import 'package:latlong2/latlong.dart';

import 'package:mcdmx/state/network.dart';
import 'package:mcdmx/state/scheme.dart';

class MapRoute extends StatelessWidget {
  final List<Station> _route;

  MapRoute(this._route);

  LatLngBounds calculateBounds(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLon = points.first.longitude;
    double maxLon = points.first.longitude;

    for (final point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLon) minLon = point.longitude;
      if (point.longitude > maxLon) maxLon = point.longitude;
    }

    return LatLngBounds(
        LatLng(minLat, minLon),
        LatLng(maxLat, maxLon),
    );
  }

  @override
    Widget build(BuildContext context) {
      final scheme = context.watch<SchemeState>();
      final network = context.watch<NetworkState>();

      final theme = Theme.of(context);

      return Stack(
          children: [
          FlutterMap(
            options: MapOptions(initialCameraFit: CameraFit.bounds(
              bounds: calculateBounds(_route.map((station) => station.coords).toList()),
              maxZoom: 13,
              padding: EdgeInsets.only(top: 50, bottom: 150, left: 40, right: 40),
            )),
            children: [
            TileLayer(
              urlTemplate: scheme.isDarkMode
              ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
              : 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
              userAgentPackageName: 'com.example.mcdmx',
            ),
            PolylineLayer(
              polylines: [
              for (var i = 0; i + 1 < _route.length; ++i)
                Polyline(
                  strokeWidth: 4,
                  color: NetworkStyle.lineColor(network.lineBetweenStations(_route[i],_route[i+1])!),
                  points: [
                    _route[i].coords,
                    _route[i+1].coords,
                  ]
                ),
              ],
              ),
            MarkerLayer(
                markers: [
                for (final station in _route)
                Marker(
                  width: 36,
                  height: 36,
                  point: station.coords,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(Format.borderRadius),
                      splashColor: NetworkStyle.lineColor(station.lines.first).withValues(alpha: 0.2),
                      child: Center(
                        child: Image.asset(
                          NetworkStyle.fromStation(station),
                          width: 28,
                          height: 28,
                          fit: BoxFit.contain,
                          ),
                        )
                      ),
                    ),
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


class MapCDMX extends StatelessWidget {
  final LatLng _defaultCoords;
  final void Function(Station station) _onTap;

  MapCDMX(this._defaultCoords, this._onTap);

  @override
  Widget build(BuildContext context) {
    final scheme = context.watch<SchemeState>();
    final network = context.watch<NetworkState>();

    final theme = Theme.of(context);

    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(initialCenter: _defaultCoords),
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
                    strokeWidth: 4,
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
                    width: 36,
                    height: 36,
                    point: station.coords,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _onTap(station),
                        borderRadius: BorderRadius.circular(Format.borderRadius),
                        splashColor: NetworkStyle.lineColor(station.lines.first).withValues(alpha: 0.2),
                        child: Center(
                          child: Image.asset(
                            NetworkStyle.fromStation(station),
                            width: 28,
                            height: 28,
                            fit: BoxFit.contain,
                          ),
                        )
                      ),
                    ),
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
