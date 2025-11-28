import 'line.dart';

class Station {
  final String _name;
  final List<Line> _lines;

  final (double x, double y) _coordinates;
  final bool _accesible;

  Station(this._name, this._coordinates, this._accesible) : _lines = [];

  String get name => _name;
  Iterator<Line> get lines => _lines.iterator;

  (double x, double y) get coordinates => _coordinates;
  bool get accesible => _accesible;

  set lines(List<Line> lines) => _lines = lines;
}
