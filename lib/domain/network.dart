import 'dart:io';

import './line.dart';
import './stop.dart';
import './station.dart';
import './edge.dart';

class TimeOfDay {
  final int hour;
  final int minute;

  const TimeOfDay(this.hour, this.minute)
    : assert(0 <= hour && hour <= 23),
      assert(0 <= minute && minute <= 59);
}

class Network {
  final List<Line> _lines;
  final List<Station> _stations;

  final Map<Stop, Set<Edge>> _connections;

  final TimeOfDay _openingTime;
  final TimeOfDay _closingTime;

  Network(this._lines, this._stations, this._connections, this._openingTime, this._closingTime);

  List<Line> get lines => _lines;
  List<Station> get stations => _stations;

  Map<Stop, Set<Edge>> get connections => _connections;

  TimeOfDay get openingTime => _openingTime;
  TimeOfDay get closingTime => _closingTime;

  // TODO: implementar
  factory Network.fromFile(File file, TimeOfDay openingHour, TimeOfDay closingHour) {
    final List<Line> lines = [];
    final List<Station> stations = [];
    final Map<Stop, Set<Edge>> connections = {};

    return Network(lines, stations, connections, openingHour, closingHour);
  }
}
