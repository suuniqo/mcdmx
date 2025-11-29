import 'line.dart';

class Station {
  final String _name;
  final (double x, double y) _coordinates;
  final bool _accesible;

  final Set<Line> _lines = {};

  Station(this._name, this._coordinates, this._accesible);

  String get name => _name;
  Set<Line> get lines => Set.unmodifiable(_lines);
  (double x, double y) get coordinates => _coordinates;
  bool get accesible => _accesible;
  
  void addLine(Line line) => _lines.add(line);
}
