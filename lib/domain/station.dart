import 'line.dart';

import 'package:latlong2/latlong.dart';

class Station {
  final String _name;
  final LatLng _coords;
  final bool _accesible;

  final Set<Line> _lines = {};

  Station(this._name, this._coords, this._accesible);

  String get name => _name;
  Set<Line> get lines => Set.unmodifiable(_lines);
  LatLng get coords => _coords;
  bool get accesible => _accesible;
  
  void addLine(Line line) => _lines.add(line);

  @override
  String toString() {
    return "Station($_name)";
  }
}
