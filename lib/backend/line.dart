import 'network.dart';
import 'stop.dart';

class Direction {
  final String _name;
  final bool _forward;
  final Line _line;

  Direction(this._name, this._line, this._forward);

  String get name => _name;
  Line get line => _line;
  bool get forward => _forward;
  Iterator<Stop> get stops => _forward ? _line._stops.iterator : _line._stops.reversed.iterator;

  int _adaptIndex(int i) {
    assert(0 <= i && i < _line.length);

    return switch(forward) {
      true  => i,
      false => _line.length - 1 - i,
    };
  }

  int? stopIndex(Stop stop) {
    var idx = _line._stopIndex[stop];

    if (idx == null) return null;

    return _adaptIndex(idx);
  }
  
  Stop nthStop(int n) {
    return _line._stops[_adaptIndex(n)];
  }

  int nthTimeOffset(int n) {
    return _line._timeOffsets[_adaptIndex(n)];
  }

  Duration nextArrivalDuration(Stop stop) {
    TimeOfDay opening = _line._network.openingTime;
    TimeOfDay closing = _line._network.closingTime;

    final DateTime now = DateTime.now();

    final openingDate = now.copyWith(hour: opening.hour, minute: opening.minute, second: 0);
    final closingDate = now.copyWith(hour: closing.hour, minute: closing.minute, second: 0);

    final idx = _line._stopIndex[stop];

    if (idx == null) throw Exception("Se intento ver cuanto tarda en llegar un tren a la parada $stop que no es de la linea $_line");

    final offset = Duration(minutes: _line._timeOffsets[idx]);

    if (now.isBefore(openingDate)) {
      return openingDate.add(offset).difference(now);
    }

    if (now.isAfter(closingDate)) {
      return openingDate.add(offset).add(Duration(days: 1)).difference(now);
    }

    final minutesSinceLastTrain = now.difference(openingDate.add(offset)).inMinutes;

    return Duration(minutes: _line._trainFreq - minutesSinceLastTrain % _line._trainFreq);
  }
}

class Line {
    final int _number;
    final List<Stop> _stops;
    final List<int> _timeOffsets; // Lo que tarda un tren en llegar a la estación n-ésima. El primer elemento siempre será cero.
    final Network _network;
    final int _trainFreq;         // Cada cuantos minutos sale un tren de la primera estación

    late final Map<Stop, int> _stopIndex;
    late final Direction _forwardDir;
    late final Direction _backwardDir;

    Line(this._network, this._number, this._stops, this._trainFreq, this._timeOffsets, String _forwardDirName, String _backwardDirName) {
      _stopIndex = _stops.asMap().map((idx, stop) => MapEntry(stop, idx));
      _forwardDir = Direction(_forwardDirName, this, true);
      _backwardDir = Direction(_backwardDirName, this, false);
    }

    int get number => _number;
    int get length => _stops.length;
    int get trainFreq => _trainFreq;

    Direction get forwardDir => _forwardDir;
    Direction get backwardDir => _backwardDir;
    Iterator<Stop> get stops => _stops.iterator;
    Network get netwrok => _network;
}
