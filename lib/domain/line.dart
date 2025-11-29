import 'package:flutter/material.dart';
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

  Iterable<Station> get stations =>
      _forward ? _line._stations : _line._stations.reversed;

  int _adaptIndex(int i) {
    assert(0 <= i && i < _line.length);

    return switch (forward) {
      true => i,
      false => _line.length - 1 - i,
    };
  }

  int? stationIndex(Station station) {
    var idx = _line._stationIndex[station];

    if (idx == null) return null;

    return _adaptIndex(idx);
  }

  Station nthStop(int n) {
    return _line._stations[_adaptIndex(n)];
  }

  int nthTimeOffset(int n) {
    return _forward
        ? _line._timeOffsets[n]
        : _line._timeOffsets[_adaptIndex(0)] -
              _line._timeOffsets[_adaptIndex(n)];
  }

  Duration nextArrivalDuration(Station station, DateTime time) {
    TimeOfDay opening = _line._network.openingTime(time);
    TimeOfDay closing = _line._network.closingTime;

    final openingDate = time.copyWith(
      hour: opening.hour,
      minute: opening.minute,
      second: 0,
    );

    final closingDate = time.copyWith(
      hour: closing.hour,
      minute: closing.minute,
      second: 0,
    );

    final ambiguousIdx = _line._stationIndex[station];

    if (ambiguousIdx == null) {
      throw Exception(
        "Se intento ver cuanto tarda en llegar un tren a la parada $station que no es de la linea $_line",
      );
    }

    final idx = _adaptIndex(ambiguousIdx);

    final offset = Duration(minutes: nthTimeOffset(idx));

    if (time.isBefore(openingDate)) {
      // hora de apertura + lo que tarda el primer tren - hora actual
      return openingDate.add(offset).difference(time);
    }

    if (time.isAfter(closingDate)) {
      // hora de apertura del día siguiente + lo que tarda el primer tren - hora actual
      final nextDay = time.add(Duration(days: 1));
      final nextOpening = _line._network.openingTime(nextDay);

      final nextOpeningDate = nextDay.copyWith(
        hour: nextOpening.hour,
        minute: nextOpening.minute,
      );

      return nextOpeningDate.add(offset).difference(time);
    }

    final minutesSinceLastTrain = time
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
  final Network _network;
  final int
  _trainFreq; // Cada cuantos minutos sale un tren de la primera estación

  late final Map<Station, int> _stationIndex;

  final List<int>
  _timeOffsets; // Lo que tarda un tren en llegar a la estación n-ésima. El primer elemento siempre será cero.

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
  Iterable<Station> get stations => _stations;

  String get logo {
    switch (_number){
      case 1:
       return 'assets/images/linea1logo.png';
      case 3:
        return 'assets/images/linea3logo.png';
      case 7:
        return 'assets/images/linea7logo.png';
      case 9:
        return 'assets/images/linea9logo.png';
      case 12:
        return 'assets/images/linea12logo.png';
      default:
        return 'assets/images/linea1.png';
    }
  }
}
