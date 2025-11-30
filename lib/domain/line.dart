import 'package:flutter/material.dart';

import 'network.dart';
import 'station.dart';

class Direction {
  //begin first peak
  static const TimeOfDay begPeakFirst = TimeOfDay(hour: 6, minute: 0);
  //end first peak
  static const TimeOfDay endPeakFirst = TimeOfDay(hour: 9, minute: 0);
  //begin second peak
  static const TimeOfDay begPeakSec = TimeOfDay(hour: 18, minute: 0);
  //end second peak
  static const TimeOfDay endPeakSec = TimeOfDay(hour: 20, minute: 0);

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

  // Índice relativo de la estación
  // respecto a esta dirección
  int? stationIndex(Station station) {
    var idx = _line._stationIndex[station];

    if (idx == null) return null;

    return _adaptIndex(idx);
  }

  // Devuelve la n-ésima estación
  // respecto a esta dirección
  Station nthStop(int n) {
    return _line._stations[_adaptIndex(n)];
  }

  // Devuelve lo que tarda un metro
  // en llegar a la estación n-ésima
  // desde que sale de la primera
  int nthTimeOffset(int n) {
    return _forward
        ? _line._timeOffsets[n]
        : _line._timeOffsets[_adaptIndex(0)] -
              _line._timeOffsets[_adaptIndex(n)];
  }

  // Calcula, si te situas en la parada
  // de la estación curr de esta dirección,
  // si se llegará a target si se permanece
  // en este sentido sin hacer transbordos
  bool isFollowingStation(Station curr, Station target) {
    final currIdx = stationIndex(target);
    final targetIdx = stationIndex(target);

    if (currIdx == null || targetIdx == null) {
      return false;
    }

    return currIdx < targetIdx;
  }

  // Retorna lo que tarda en llegar el siguiente tren
  // a la estación station a la hora time
  Duration nextArrivalDuration(Station station, DateTime now) {
    DateTime timeAsDate(TimeOfDay time, DateTime date) {
      return date.copyWith(
        hour: time.hour,
        minute: time.minute,
        second: 0,
      );
    }

    TimeOfDay opening = _line.network!.openingTime(now);
    TimeOfDay closing = _line.network!.closingTime;
    
    final openingDate = timeAsDate(opening, now);
    final closingDate = timeAsDate(closing, now);

    final ambiguousIdx = _line._stationIndex[station];

    if (ambiguousIdx == null) {
      throw Exception(
        "Se intento ver cuanto tarda en llegar un tren a la parada $station que no es de la linea $_line",
      );
    }

    final idx = _adaptIndex(ambiguousIdx);

    final offset = Duration(minutes: nthTimeOffset(idx));

    if (now.isBefore(openingDate)) {
      // hora de apertura + lo que tarda el primer tren - hora actual
      return openingDate.add(offset).difference(now);
    }

    if (closingDate.isAfter(openingDate) && now.isAfter(closingDate)) {
      // hora de apertura del día siguiente + lo que tarda el primer tren - hora actual
      final nextDay = now.add(Duration(days: 1));
      final nextOpening = _line.network!.openingTime(nextDay);

      final nextOpeningDate = nextDay.copyWith(
        hour: nextOpening.hour,
        minute: nextOpening.minute,
      );

      return nextOpeningDate.add(offset).difference(now);
    }

    final beg = openingDate.add(offset);

    final begPeakFirstDate = timeAsDate(begPeakFirst, now).add(offset);
    final endPeakFirstDate = timeAsDate(endPeakFirst, now).add(offset);

    final begPeakSecDate = timeAsDate(begPeakSec, now).add(offset);
    final endPeakSecDate = timeAsDate(endPeakSec, now).add(offset);

    Duration nextArrivalRelative(DateTime beg, DateTime now, int freq) {
      return Duration(minutes: freq - now.difference(beg).inMinutes % freq);
    }

    if (now.isBefore(begPeakFirstDate)) {
      return nextArrivalRelative(beg, now, line.trainFreq.flat);
    }

    if (now.isAfter(begPeakFirstDate) && now.isBefore(endPeakFirstDate)) {
      return nextArrivalRelative(begPeakFirstDate, now, line.trainFreq.peak);
    }

    if (now.isAfter(endPeakFirstDate) && now.isBefore(begPeakSecDate)) {
      return nextArrivalRelative(endPeakFirstDate, now, line.trainFreq.flat);
    }

    if (now.isAfter(begPeakSecDate) && now.isBefore(endPeakSecDate)) {
      return nextArrivalRelative(begPeakSecDate, now, line.trainFreq.peak);
    }

    return nextArrivalRelative(endPeakSecDate, now, line.trainFreq.flat);
  }

  @override
  String toString() {
    return "Line(\n${_line._number},\n $_name, $stations\n)\n";
  }
}

class Line {
  final int _number;
  final List<Station> _stations;
  
  /* La he hecho publica en vez de hacer getter y setters que no cumpruban nada ya que es lo que hace Dart automicamante con las variable publicas de las clases
  Dart por que harias eso? */
  Network? _network;

  /* Cada cuantos minutos sale un tren de la primera estación.
  El primer numero es durante las horas pico y el segundo durante las horas valle o no pico */
  final ({int peak, int flat}) _trainFreq; 

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
      "${_stations[0].name}-${_stations[_stations.length - 1].name}",
      this,
      true,
    );

    _backwardDir = Direction(
      "${_stations[_stations.length - 1].name}-${_stations[0].name}",
      this,
      false,
    );

    // Se añade la línea a las
    // líneas que pasan por station
    for (final station in _stations) {
      station.addLine(this);
    }
  }

  int get number => _number;
  int get length => _stations.length;
  Network? get network => _network;

  ({int peak, int flat}) get trainFreq => _trainFreq;

  Direction get forwardDir => _forwardDir;
  Direction get backwardDir => _backwardDir;

  void addTimeOffset(int timeOffset){
      _timeOffsets.add(timeOffset);
  }

  void addNetwork(Network network) {
    if (_network == null) {
      _network = network;
      return;
    }

    throw Exception("Se intento asignar un Netowork a una linea más de una vez");
  }

  @override
  String toString() {
    return "Line($_number, $_stations)";
  }
}
