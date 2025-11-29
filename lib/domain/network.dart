import 'dart:io';

import 'package:flutter/material.dart';

import 'dart:convert';

import './line.dart';
import './station.dart';
import './stop.dart';
import './edge.dart';

class Network {
  final List<Line> _lines;
  final List<Station> _stations;

  static const TimeOfDay _openingTimeReg = TimeOfDay(hour: 5, minute: 0);
  static const TimeOfDay _openingTimeSat = TimeOfDay(hour: 6, minute: 0);
  static const TimeOfDay _openingTimeSun = TimeOfDay(hour: 7, minute: 0);
  static const TimeOfDay _closingTime    = TimeOfDay(hour: 0, minute: 0);

  static const bool accesibleModeDefault = false;

  late Map<Station, Set<Stop>> _stationStops;
  late Map<Stop, Set<Edge>> _connections;

  bool _isAccesibleMode = accesibleModeDefault;

  Network(this._lines, this._stations) {
    // TODO: Rellenar

    // IMPORTANTE: Como el json tiene bastante información
    // como transbordos igual es más eficiente que connections y/o stationStops
    // sean argumentos del constructor y creados en Network.fromFile,
    // en vez de calculare a posteriori

    _stationStops = {};
    _connections = {};
  }

  Iterable<Line> get lines => _lines;
  Iterable<Station> get stations => _stations;

  bool get isAccesibleMode => _isAccesibleMode;

  Map<Stop, Set<Edge>> get connections => _connections;
  Map<Station, Set<Stop>> get stationStops => _stationStops;

  TimeOfDay get closingTime => _closingTime;

  TimeOfDay openingTime(DateTime day) {
    var weekday = day.weekday;

    if (weekday == 7) {
      return _openingTimeSun;
    }
    if (weekday == 6) {
      return _openingTimeSat;
    }

    return _openingTimeReg;
  }

  void toggleAccesibleMode() {
    _isAccesibleMode = !_isAccesibleMode;
  }

  factory Network.fromFile(File file) {
      // try{
      //     final String json = await file.readAsString();
      //
      //     final Map<String, dynamic> data = jsonDecode(json);
      //
      // }
    final List<Line> lines = [];
    final List<Station> stations = [];

    // TODO: Rellenar listas

    return Network(lines, stations);
  }
}
