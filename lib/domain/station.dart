import 'line.dart';

import 'package:latlong2/latlong.dart';

class Station {
  final String _name;
  final LatLng _coordinates;
  final bool _accesible;

  final Set<Line> _lines = {};

  Station(this._name, this._coordinates, this._accesible);

  String get name => _name;
  Set<Line> get lines => Set.unmodifiable(_lines);
  LatLng get coordinates => _coordinates;
  bool get accesible => _accesible;
  
  void addLine(Line line) => _lines.add(line);

}
