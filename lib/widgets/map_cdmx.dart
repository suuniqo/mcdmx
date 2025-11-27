import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapCDMX extends StatelessWidget {
  static const LatLng defaultCoords = LatLng(
    19.430017555308567,
    -99.13440962985258,
  );

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: defaultCoords),
    );
  }
}
