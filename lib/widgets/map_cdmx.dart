import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mcdmx/state/scheme.dart';
import 'package:provider/provider.dart';

class MapCDMX extends StatelessWidget {
  static const LatLng defaultCoords = LatLng(
    19.430017555308567,
    -99.13440962985258,
  );

  @override
  Widget build(BuildContext context) {
    final scheme = context.watch<SchemeState>();

    return FlutterMap(
      options: MapOptions(initialCenter: defaultCoords),
      children: [
        TileLayer(
          urlTemplate: scheme.isDarkMode
              ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
              : 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
          userAgentPackageName: 'com.example.mcdmx',
        ),
      ],
    );
  }
}
