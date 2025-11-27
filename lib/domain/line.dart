import 'network.dart';
import 'station.dart';

class Direction {
  final String _name;
  final bool _forward;
  final Line _line;

  Direction(this._name, this._line, this._forward);

  String get name => _name;
  Line get line => _line;
  bool get forward => _forward;
  Iterator<Station> get stations =>
      _forward ? _line._stations.iterator : _line._stations.reversed.iterator;

  int _adaptIndex(int i) {
    assert(0 <= i && i < _line.length);

    return switch (forward) {
      true => i,
      false => _line.length - 1 - i,
    };
  }

  int? stopIndex(Station station) {
    var idx = _line._stationIndex[station];

    if (idx == null) return null;

    return _adaptIndex(idx);
  }

  Station nthStop(int n) {
    return _line._stations[_adaptIndex(n)];
  }

  int nthTimeOffset(int n) {
    return _line._timeOffsets[_adaptIndex(n)];
  }

  Duration nextArrivalDuration(Station station) {
    TimeOfDay opening = _line._network.openingTime;
    TimeOfDay closing = _line._network.closingTime;

    final DateTime now = DateTime.now();

    final openingDate = now.copyWith(
      hour: opening.hour,
      minute: opening.minute,
      second: 0,
    );
    final closingDate = now.copyWith(
      hour: closing.hour,
      minute: closing.minute,
      second: 0,
    );

    final idx = _line._stationIndex[station];

    if (idx == null)
      throw Exception(
        "Se intento ver cuanto tarda en llegar un tren a la parada $station que no es de la linea $_line",
      );

    final offset = Duration(minutes: _line._timeOffsets[idx]);

    if (now.isBefore(openingDate)) {
      return openingDate.add(offset).difference(now);
    }

    if (now.isAfter(closingDate)) {
      return openingDate.add(offset).add(Duration(days: 1)).difference(now);
    }

    final minutesSinceLastTrain = now
        .difference(openingDate.add(offset))
        .inMinutes;

    return Duration(
      minutes: _line._trainFreq - minutesSinceLastTrain % _line._trainFreq,
    );
  }
}

class Line {
  final int _number;
  final List<Station> _stations;
  final List<int>
  _timeOffsets; // Lo que tarda un tren en llegar a la estación n-ésima. El primer elemento siempre será cero.
  final Network _network;
  final int
  _trainFreq; // Cada cuantos minutos sale un tren de la primera estación

  late final Map<Station, int> _stationIndex;
  late final Direction _forwardDir;
  late final Direction _backwardDir;

  Line(
    this._network,
    this._number,
    this._stations,
    this._trainFreq,
    this._timeOffsets,
  ) {
    _stationIndex = _stations.asMap().map((idx, stop) => MapEntry(stop, idx));
    _forwardDir = Direction(
      "${_stations[0].name}-${_stations[_stations.length - 1]}",
      this,
      true,
    );
    _backwardDir = Direction(
      "${_stations[_stations.length - 1].name}-${_stations[0]}",
      this,
      false,
    );
  }

  int get number => _number;
  int get length => _stations.length;
  int get trainFreq => _trainFreq;

  Direction get forwardDir => _forwardDir;
  Direction get backwardDir => _backwardDir;
  Network get netwrok => _network;
}
