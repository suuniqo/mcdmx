import './stop.dart';

class Direction {
  final String _name;
  final bool _forward;
  final Line _line;

  Direction(this._name, this._line, this._forward);

  String get name => _name;
  Line get line => _line;
  bool get forward => _forward;
  Iterator<Stop> get stops => _forward ? _line._stops.iterator : _line._stops.reversed.iterator;
}


class Line {
    final int _number;
    final List<Stop> _stops;
    final int _trainFreq; // Cada cuantos minutos sale un tren de la primera estación

    late final Direction _forwardDir;
    late final Direction _backwardDir;

    Line (this._number, this._stops, this._trainFreq, String _forwardDirName, String _backwardDirName) {
      _forwardDir = Direction(_forwardDirName, this, true);
      _backwardDir = Direction(_backwardDirName, this, false);
    }

    int get number => _number;
    int get numStops => _stops.length;
    int get trainFreq => _trainFreq;

    Direction get forwardDir => _forwardDir;
    Direction get backwardDir => _backwardDir;
    Iterator<Stop> get stops => _stops.iterator;

    Stop nthStop(int n) => _stops[n];
}
