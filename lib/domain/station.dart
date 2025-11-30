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
  
  // Las líneas que pasan por Station se añaden
  // a posteriori cuando se crea una línea que 
  // pasa por ella
  void addLine(Line line) => _lines.add(line);

  @override
  String toString() {
    return "Station($_name)";
  }
}
