import 'stop.dart';

class Station {
  final List<Stop> _stops;
  final (double x, double y) _coordinates;
  final bool _accesible;
  // TODO: final List<Landmark> _landmarks;

  Station(this._stops, this._coordinates, this._accesible);

  (double x, double y) get coordinates => _coordinates;
  Iterator<Stop> get stops => _stops.iterator;
  bool get accesible => _accesible;
}
