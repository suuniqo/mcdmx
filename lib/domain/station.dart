import 'line.dart';

class Station {
  final String _name;
  final List<Line> _lines;

  final (double x, double y) _coordinates;
  final bool _accesible;
  // TODO: final List<Landmark> _landmarks;

<<<<<<< HEAD
  Station(this._stops, this._coordinates, this._accesible);
=======
  Station(this._name, this._lines, this._coordinates, this._accesible);

  String get name => _name;
  Iterator<Line> get lines => _lines.iterator;

>>>>>>> dev
  (double x, double y) get coordinates => _coordinates;
  bool get accesible => _accesible;
  
}
