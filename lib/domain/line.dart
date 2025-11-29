import 'package:flutter/material.dart';

import 'network.dart';
import 'station.dart';

class Direction {
  //begin first peak
  static const TimeOfDay begfpeak = TimeOfDay(hour: 6, minute: 0);
  //end first peak
  static const TimeOfDay endfpeak = TimeOfDay(hour: 9, minute: 0);
  //begin second peak
  static const TimeOfDay begspeak = TimeOfDay(hour: 18, minute: 0);
  //end second peak
  static const TimeOfDay endspeak = TimeOfDay(hour: 20, minute: 0);
  
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

  bool isFollowingStation(Station curr, Station target) {
    final currIdx = stationIndex(target);
    final targetIdx = stationIndex(target);

    if (currIdx == null || targetIdx == null) {
      return false;
    }

    return currIdx < targetIdx;
  }

  Duration nextArrivalDuration(Station station, DateTime time) {
    TimeOfDay opening = _line.network.openingTime(time);
    TimeOfDay closing = _line.network.closingTime;

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
      final nextOpening = _line.network.openingTime(nextDay);

      final nextOpeningDate = nextDay.copyWith(
        hour: nextOpening.hour,
        minute: nextOpening.minute,
      );

      return nextOpeningDate.add(offset).difference(time);
    }

    final minutesSinceLastTrain = time
        .difference(openingDate.add(offset))
        .inMinutes;
    
    final begfpeakDate = time.copyWith(
      hour: begfpeak.hour,
      minute: begfpeak.minute,
      second: 0,
    );
    final endfpeakDate = time.copyWith(
      hour: endfpeak.hour,
      minute: endfpeak.minute,
      second: 0,
    );
    final begspeakDate = time.copyWith(
      hour: begspeak.hour,
      minute: begspeak.minute,
      second: 0,
    );
    final endspeakDate = time.copyWith(
      hour: endspeak.hour,
      minute: endspeak.minute,
      second: 0,
    );

    if((time.isAfter(begfpeakDate) && time.isBefore(endfpeakDate)) || (time.isAfter(begspeakDate) && time.isBefore(endspeakDate))){
        return Duration(
        minutes: _line._trainFreq.$1 - minutesSinceLastTrain % _line._trainFreq.$1,
        );
    }
    return Duration(
      minutes: _line._trainFreq.$2 - minutesSinceLastTrain % _line._trainFreq.$2,
    );
  }
}

class Line {
  final int _number;
  final List<Station> _stations;
  
  /* La he hecho publica en vez de hacer getter y setters que no cumpruban nada ya que es lo que hace Dart automicamante con las variable publicas de las clases
  Dart por que harias eso? */
  late final Network network;

  /* Cada cuantos minutos sale un tren de la primera estación.
  El primer numero es durante las horas pico y el segundo durante las horas valle o no pico */
  final (int, int) _trainFreq; 

  late final Map<Station, int> _stationIndex;

  final List<int> _timeOffsets; // Lo que tarda un tren en llegar a la estación n-ésima. El primer elemento siempre será cero.

  late final Direction _forwardDir;
  late final Direction _backwardDir;

  Line(
    this._number,
    this._stations,
    this._trainFreq,
  ) : _timeOffsets = [] {
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

    for (final station in _stations) {
      station.addLine(this);
    }
  }

  int get number => _number;
  int get length => _stations.length;
  (int, int) get trainFreq => _trainFreq;

  Direction get forwardDir => _forwardDir;
  Direction get backwardDir => _backwardDir;

  Iterable<Station> get stations => _stations;
  

  void addTimeOffset(int timeOffset){
      _timeOffsets.add(timeOffset);
  }
}
