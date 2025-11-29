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
  
  // Las líneas que pasan por Station se añaden
  // a posteriori cuando se crea una línea que 
  // pasa por ella
  void addLine(Line line) => _lines.add(line);
}
